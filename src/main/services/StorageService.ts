// Storage service - handles saving/loading screenshots
import * as fs from 'fs/promises';
import * as path from 'path';
import { app } from 'electron';
import * as sharp from 'sharp';

export class StorageService {
    private screenshotsDir: string;
    private metadataDir: string;

    constructor() {
        const userDataPath = app.getPath('userData');
        this.screenshotsDir = path.join(userDataPath, 'screenshots');
        this.metadataDir = path.join(userDataPath, 'metadata');

        // Create directories if they don't exist
        this.initDirectories();
    }

    private async initDirectories() {
        try {
            await fs.mkdir(this.screenshotsDir, { recursive: true });
            await fs.mkdir(this.metadataDir, { recursive: true });
        } catch (error) {
            console.error('Failed to create directories:', error);
        }
    }

    async saveScreenshot(screenshot: any, imageDataUrl: string): Promise<void> {
        try {
            const filename = `${screenshot.id}.png`;
            const imagePath = path.join(this.screenshotsDir, filename);
            const metadataPath = path.join(this.metadataDir, `${screenshot.id}.json`);

            // Convert data URL to buffer
            const base64Data = imageDataUrl.replace(/^data:image\/png;base64,/, '');
            const buffer = Buffer.from(base64Data, 'base64');

            // Save image
            await fs.writeFile(imagePath, buffer);

            // Save metadata
            await fs.writeFile(metadataPath, JSON.stringify(screenshot, null, 2));

        } catch (error) {
            console.error('Failed to save screenshot:', error);
            throw error;
        }
    }

    async loadScreenshots(): Promise<any[]> {
        try {
            const metadataFiles = await fs.readdir(this.metadataDir);
            const screenshots = [];

            for (const file of metadataFiles) {
                if (file.endsWith('.json')) {
                    const metadataPath = path.join(this.metadataDir, file);
                    const data = await fs.readFile(metadataPath, 'utf-8');
                    const screenshot = JSON.parse(data);
                    screenshots.push(screenshot);
                }
            }

            // Sort by created date (newest first)
            return screenshots.sort((a, b) =>
                new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
            );

        } catch (error) {
            console.error('Failed to load screenshots:', error);
            return [];
        }
    }

    async exportImage(imageDataUrl: string, format: string, filePath: string): Promise<string> {
        try {
            const base64Data = imageDataUrl.replace(/^data:image\/\w+;base64,/, '');
            const buffer = Buffer.from(base64Data, 'base64');

            if (format === 'png') {
                await fs.writeFile(filePath, buffer);
            } else if (format === 'jpeg' || format === 'jpg') {
                await sharp(buffer)
                    .jpeg({ quality: 90 })
                    .toFile(filePath);
            } else if (format === 'pdf') {
                // PDF export would require additional library
                await fs.writeFile(filePath, buffer);
            }

            return filePath;

        } catch (error) {
            console.error('Failed to export image:', error);
            throw error;
        }
    }

    async deleteScreenshot(id: string): Promise<void> {
        try {
            const imagePath = path.join(this.screenshotsDir, `${id}.png`);
            const metadataPath = path.join(this.metadataDir, `${id}.json`);

            await fs.unlink(imagePath);
            await fs.unlink(metadataPath);

        } catch (error) {
            console.error('Failed to delete screenshot:', error);
            throw error;
        }
    }
}
