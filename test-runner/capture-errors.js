const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');
const http = require('http');

const OUTPUT_FILE = path.join(__dirname, 'errors.log');
const GAME_DIR = path.join(__dirname, '..', 'export', 'html5', 'bin');
const PORT = 8080;

// Simple static file server
function startServer() {
    return new Promise((resolve) => {
        const server = http.createServer((req, res) => {
            // Strip query string and decode URL
            let urlPath = decodeURIComponent(req.url.split('?')[0]);
            let filePath = path.join(GAME_DIR, urlPath === '/' ? 'index.html' : urlPath);
            const ext = path.extname(filePath).toLowerCase();
            const mimeTypes = {
                '.html': 'text/html',
                '.js': 'application/javascript',
                '.css': 'text/css',
                '.png': 'image/png',
                '.jpg': 'image/jpeg',
                '.gif': 'image/gif',
                '.svg': 'image/svg+xml',
                '.json': 'application/json',
                '.woff': 'font/woff',
                '.woff2': 'font/woff2',
                '.ogg': 'audio/ogg',
                '.mp3': 'audio/mpeg',
                '.wav': 'audio/wav'
            };
            const contentType = mimeTypes[ext] || 'application/octet-stream';

            fs.readFile(filePath, (err, content) => {
                if (err) {
                    console.log(`404: ${urlPath} -> ${filePath}`);
                    fs.appendFileSync(OUTPUT_FILE, `404 NOT FOUND: ${urlPath} (file: ${filePath})\n`);
                    res.writeHead(404);
                    res.end('Not found: ' + filePath);
                } else {
                    res.writeHead(200, { 'Content-Type': contentType });
                    res.end(content);
                }
            });
        });
        server.listen(PORT, () => {
            console.log(`Server running at http://localhost:${PORT}/`);
            resolve(server);
        });
    });
}

(async () => {
    const log = (msg) => {
        console.log(msg);
        fs.appendFileSync(OUTPUT_FILE, msg + '\n');
    };

    // Clear previous log
    fs.writeFileSync(OUTPUT_FILE, `Error capture started: ${new Date().toISOString()}\n\n`);

    log('Starting local server...');
    const server = await startServer();

    log('Launching browser...\n');

    const browser = await puppeteer.launch({
        headless: true,
        args: ['--no-sandbox']
    });

    const page = await browser.newPage();

    // Capture console messages
    page.on('console', msg => {
        const type = msg.type();
        const text = msg.text();
        if (type === 'error') {
            log(`ERROR: ${text}`);
        } else if (type === 'warning') {
            log(`WARN: ${text}`);
        }
    });

    // Capture page errors (uncaught exceptions)
    page.on('pageerror', error => {
        log(`PAGE ERROR: ${error.message}`);
        if (error.stack) {
            log(error.stack.split('\n').slice(0, 10).join('\n'));
        }
    });

    // Capture failed requests (missing assets)
    page.on('requestfailed', request => {
        log(`REQUEST FAILED: ${request.url()} - ${request.failure().errorText}`);
    });

    log('Loading http://localhost:8080...\n');

    try {
        await page.goto('http://localhost:8080', {
            waitUntil: 'networkidle0',
            timeout: 30000
        });

        log('Page loaded, waiting 5 seconds for game init...\n');
        await new Promise(r => setTimeout(r, 5000));

        const canvas = await page.$('canvas');
        log(canvas ? 'Canvas found - game is rendering' : 'No canvas - game failed to start');

    } catch (error) {
        log(`LOAD ERROR: ${error.message}`);
    }

    await browser.close();
    server.close();
    log('\nDone.');
    log(`\nErrors written to: ${OUTPUT_FILE}`);
})();
