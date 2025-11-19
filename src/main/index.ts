// Main process entry point
import { app, BrowserWindow, Tray, Menu, globalShortcut, ipcMain, clipboard, nativeImage } from 'electron';
import * as path from 'path';
import Store from 'electron-store';
import { ScreenshotService } from './services/ScreenshotService';
import { RenderService } from './services/RenderService';
import { StorageService } from './services/StorageService';

// Electron Store for settings
const store = new Store();

let mainWindow: BrowserWindow | null = null;
let tray: Tray | null = null;
let quickPreviewWindow: BrowserWindow | null = null;

// Services
const screenshotService = new ScreenshotService();
const renderService = new RenderService();
const storageService = new StorageService();

function createMainWindow() {
    mainWindow = new BrowserWindow({
        width: 1200,
        height: 700,
        minWidth: 900,
        minHeight: 500,
        show: false,
        webPreferences: {
            nodeIntegration: false,
            contextIsolation: true,
            preload: path.join(__dirname, 'preload.js')
        },
        titleBarStyle: 'hiddenInset',
        trafficLightPosition: { x: 10, y: 10 }
    });

    mainWindow.loadFile(path.join(__dirname, '../renderer/editor.html'));

    mainWindow.once('ready-to-show', () => {
        mainWindow?.show();
    });

    mainWindow.on('closed', () => {
        mainWindow = null;
    });
}

function createTray() {
    // Create tray icon
    const iconPath = path.join(__dirname, '../assets/tray-icon.png');

    // Create tray with icon if exists, otherwise use native image
    try {
        if (require('fs').existsSync(iconPath)) {
            tray = new Tray(iconPath);
        } else {
            // Create a simple native image as fallback
            const icon = nativeImage.createEmpty();
            tray = new Tray(icon);
        }
    } catch (error) {
        console.error('Tray icon error:', error);
        const icon = nativeImage.createEmpty();
        tray = new Tray(icon);
    }

    const contextMenu = Menu.buildFromTemplate([
        {
            label: 'New Screenshot',
            accelerator: 'CommandOrControl+Shift+C',
            click: () => performQuickCapture()
        },
        {
            label: 'Open Library',
            accelerator: 'CommandOrControl+Shift+L',
            click: () => openLibrary()
        },
        { type: 'separator' },
        {
            label: 'Settings',
            click: () => openSettings()
        },
        { type: 'separator' },
        {
            label: 'Quit CodeSnap',
            click: () => app.quit()
        }
    ]);

    tray.setToolTip('CodeSnap - Beautiful Code Screenshots');
    tray.setContextMenu(contextMenu);

    // Click on tray icon to show quick capture
    tray.on('click', () => {
        performQuickCapture();
    });
}

function createQuickPreviewWindow(screenshot: any) {
    quickPreviewWindow = new BrowserWindow({
        width: 600,
        height: 400,
        show: false,
        frame: false,
        transparent: true,
        alwaysOnTop: true,
        webPreferences: {
            nodeIntegration: false,
            contextIsolation: true,
            preload: path.join(__dirname, 'preload.js')
        }
    });

    quickPreviewWindow.loadFile(path.join(__dirname, '../renderer/preview.html'));

    quickPreviewWindow.once('ready-to-show', () => {
        // Send screenshot data to renderer
        quickPreviewWindow?.webContents.send('screenshot-data', screenshot);
        quickPreviewWindow?.show();
    });

    quickPreviewWindow.on('closed', () => {
        quickPreviewWindow = null;
    });

    // Auto-close after 30 seconds
    setTimeout(() => {
        if (quickPreviewWindow && !quickPreviewWindow.isDestroyed()) {
            quickPreviewWindow.close();
        }
    }, 30000);
}

async function performQuickCapture() {
    try {
        // Get code from clipboard
        const code = clipboard.readText();

        if (!code || code.trim().length === 0) {
            return;
        }

        // Detect language
        const language = detectLanguage(code);

        // Get settings
        const settings = store.get('settings', getDefaultSettings());

        // Create screenshot object
        const screenshot = {
            id: Date.now().toString(),
            code,
            language,
            theme: settings.defaultTheme,
            windowStyle: settings.defaultWindowStyle,
            backgroundColor: settings.defaultBackground,
            fontSize: settings.defaultFontSize,
            fontFamily: settings.defaultFontFamily,
            padding: settings.defaultPadding,
            shadow: settings.defaultShadow,
            borderRadius: settings.defaultBorderRadius,
            showLineNumbers: settings.defaultShowLineNumbers,
            exportSize: settings.defaultExportSize,
            createdAt: new Date().toISOString()
        };

        // Render screenshot
        const imageDataUrl = await renderService.render(screenshot, settings.showWatermark, settings.watermarkText);

        // Save to library if enabled
        if (settings.autoSaveScreenshots) {
            await storageService.saveScreenshot(screenshot, imageDataUrl);
        }

        // Show quick preview
        createQuickPreviewWindow({ ...screenshot, imageDataUrl });

    } catch (error) {
        console.error('Quick capture failed:', error);
    }
}

function registerGlobalShortcuts() {
    // Quick capture: Cmd/Ctrl+Shift+C
    globalShortcut.register('CommandOrControl+Shift+C', () => {
        performQuickCapture();
    });

    // Open library: Cmd/Ctrl+Shift+L
    globalShortcut.register('CommandOrControl+Shift+L', () => {
        openLibrary();
    });
}

function openLibrary() {
    if (!mainWindow) {
        createMainWindow();
    } else {
        mainWindow.show();
        mainWindow.focus();
    }
    mainWindow?.webContents.send('navigate-to', 'library');
}

function openSettings() {
    if (!mainWindow) {
        createMainWindow();
    } else {
        mainWindow.show();
        mainWindow.focus();
    }
    mainWindow?.webContents.send('navigate-to', 'settings');
}

function detectLanguage(code: string): string {
    // Simple language detection based on patterns
    if (code.includes('function') || code.includes('const') || code.includes('=>')) {
        return 'javascript';
    }
    if (code.includes('def ') && code.includes(':')) {
        return 'python';
    }
    if (code.includes('func ') && code.includes(' -> ')) {
        return 'swift';
    }
    if (code.includes('package ') && code.includes('func ')) {
        return 'go';
    }
    if (code.includes('fn ') && code.includes(' -> ')) {
        return 'rust';
    }
    return 'plaintext';
}

function getDefaultSettings() {
    return {
        defaultTheme: 'github-dark',
        defaultWindowStyle: 'macos',
        defaultBackground: { type: 'gradient', start: '#667eea', end: '#764ba2' },
        defaultFontSize: 14,
        defaultFontFamily: 'JetBrains Mono',
        defaultPadding: 48,
        defaultShadow: { enabled: true, size: 40, blur: 60, opacity: 0.3, offsetY: 8 },
        defaultBorderRadius: 12,
        defaultShowLineNumbers: true,
        defaultExportSize: 2,
        autoSaveScreenshots: true,
        showWatermark: true,
        watermarkText: 'Created with CodeSnap'
    };
}

// IPC Handlers
ipcMain.handle('render-screenshot', async (_event, screenshot) => {
    const settings = store.get('settings', getDefaultSettings());
    return await renderService.render(screenshot, settings.showWatermark, settings.watermarkText);
});

ipcMain.handle('save-screenshot', async (_event, screenshot, imageDataUrl) => {
    return await storageService.saveScreenshot(screenshot, imageDataUrl);
});

ipcMain.handle('load-screenshots', async () => {
    return await storageService.loadScreenshots();
});

ipcMain.handle('get-settings', async () => {
    return store.get('settings', getDefaultSettings());
});

ipcMain.handle('save-settings', async (_event, settings) => {
    store.set('settings', settings);
    return true;
});

ipcMain.handle('copy-to-clipboard', async (_event, imageDataUrl) => {
    const image = nativeImage.createFromDataURL(imageDataUrl);
    clipboard.writeImage(image);
    return true;
});

ipcMain.handle('export-image', async (_event, imageDataUrl, format, filePath) => {
    return await storageService.exportImage(imageDataUrl, format, filePath);
});

// App lifecycle
app.whenReady().then(() => {
    createTray();
    registerGlobalShortcuts();

    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) {
            createMainWindow();
        }
    });
});

app.on('window-all-closed', () => {
    // Keep app running in tray
    // Don't quit on macOS
    if (process.platform !== 'darwin') {
        // On Windows/Linux, quit when all windows are closed
        // But we want to keep tray, so do nothing
    }
});

app.on('will-quit', () => {
    globalShortcut.unregisterAll();
});

// Prevent app from quitting when last window is closed (keep in tray)
app.on('before-quit', (event) => {
    // Only quit if explicitly requested
});
