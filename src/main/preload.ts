// Preload script - bridge between main and renderer
import { contextBridge, ipcRenderer } from 'electron';

// Expose protected methods that allow the renderer process to use
// ipcRenderer without exposing the entire object
contextBridge.exposeInMainWorld('electronAPI', {
    // Rendering
    renderScreenshot: (screenshot: any) => ipcRenderer.invoke('render-screenshot', screenshot),

    // Storage
    saveScreenshot: (screenshot: any, imageDataUrl: string) =>
        ipcRenderer.invoke('save-screenshot', screenshot, imageDataUrl),
    loadScreenshots: () => ipcRenderer.invoke('load-screenshots'),

    // Settings
    getSettings: () => ipcRenderer.invoke('get-settings'),
    saveSettings: (settings: any) => ipcRenderer.invoke('save-settings', settings),

    // Clipboard
    copyToClipboard: (imageDataUrl: string) => ipcRenderer.invoke('copy-to-clipboard', imageDataUrl),

    // Export
    exportImage: (imageDataUrl: string, format: string, filePath: string) =>
        ipcRenderer.invoke('export-image', imageDataUrl, format, filePath),

    // Events
    onScreenshotData: (callback: (data: any) => void) => {
        ipcRenderer.on('screenshot-data', (_event, data) => callback(data));
    },

    onNavigateTo: (callback: (page: string) => void) => {
        ipcRenderer.on('navigate-to', (_event, page) => callback(page));
    }
});

// TypeScript declaration
declare global {
    interface Window {
        electronAPI: {
            renderScreenshot: (screenshot: any) => Promise<string>;
            saveScreenshot: (screenshot: any, imageDataUrl: string) => Promise<void>;
            loadScreenshots: () => Promise<any[]>;
            getSettings: () => Promise<any>;
            saveSettings: (settings: any) => Promise<boolean>;
            copyToClipboard: (imageDataUrl: string) => Promise<boolean>;
            exportImage: (imageDataUrl: string, format: string, filePath: string) => Promise<string>;
            onScreenshotData: (callback: (data: any) => void) => void;
            onNavigateTo: (callback: (page: string) => void) => void;
        }
    }
}
