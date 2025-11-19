// Rendering service - converts code to beautiful images
import hljs from 'highlight.js';
import { createCanvas, loadImage, registerFont } from 'canvas';
import * as fs from 'fs';
import * as path from 'path';

export class RenderService {
    private themes: Map<string, any> = new Map();

    constructor() {
        this.loadThemes();
    }

    private loadThemes() {
        // Load all theme files
        const themesDir = path.join(__dirname, '../../themes');
        const themeFiles = fs.readdirSync(themesDir);

        themeFiles.forEach(file => {
            if (file.endsWith('.json')) {
                const themePath = path.join(themesDir, file);
                const theme = JSON.parse(fs.readFileSync(themePath, 'utf-8'));
                this.themes.set(theme.name, theme);
            }
        });
    }

    async render(screenshot: any): Promise<string> {
        const {
            code,
            language,
            theme: themeName,
            windowStyle,
            backgroundColor,
            fontSize,
            fontFamily,
            padding,
            shadow,
            borderRadius,
            showLineNumbers,
            exportSize
        } = screenshot;

        // Get theme
        const theme = this.themes.get(themeName) || this.themes.get('github-dark');

        // Highlight code
        const highlighted = this.highlightCode(code, language, theme);

        // Calculate dimensions
        const lineHeight = fontSize * 1.5;
        const lines = code.split('\n');
        const longestLine = Math.max(...lines.map(l => l.length));

        const textWidth = longestLine * fontSize * 0.6; // Approximate
        const textHeight = lines.length * lineHeight;

        const chromeHeight = this.getChromeHeight(windowStyle);
        const contentWidth = textWidth + padding * 2;
        const contentHeight = textHeight + padding * 2 + chromeHeight;

        // Calculate total size with shadow
        const shadowPadding = shadow.enabled ? shadow.blur + Math.abs(shadow.offsetY) : 0;
        const totalWidth = contentWidth + shadowPadding * 2;
        const totalHeight = contentHeight + shadowPadding * 2;

        // Create canvas
        const scale = exportSize;
        const canvas = createCanvas(totalWidth * scale, totalHeight * scale);
        const ctx = canvas.getContext('2d');

        // Scale context
        ctx.scale(scale, scale);

        // Render shadow
        if (shadow.enabled) {
            this.renderShadow(ctx, shadowPadding, shadowPadding, contentWidth, contentHeight, shadow, borderRadius);
        }

        // Render background
        this.renderBackground(ctx, shadowPadding, shadowPadding, contentWidth, contentHeight, backgroundColor, borderRadius);

        // Render window chrome
        if (windowStyle !== 'none') {
            this.renderWindowChrome(ctx, shadowPadding, shadowPadding, contentWidth, chromeHeight, windowStyle, theme.isDark, borderRadius);
        }

        // Render code
        ctx.font = `${fontSize}px "${fontFamily}", monospace`;
        ctx.fillStyle = theme.colors.foreground;

        let y = shadowPadding + padding + chromeHeight + fontSize;
        lines.forEach((line, index) => {
            const x = shadowPadding + padding;

            // Line numbers
            if (showLineNumbers) {
                ctx.fillStyle = theme.colors.comment;
                ctx.fillText(`${index + 1}`, x, y);
                ctx.fillStyle = theme.colors.foreground;
            }

            // Code
            const codeX = showLineNumbers ? x + 40 : x;
            this.renderLine(ctx, line, codeX, y, theme);

            y += lineHeight;
        });

        // Render watermark if enabled
        const settings = await window.electronAPI.getSettings();
        if (settings.showWatermark) {
            this.renderWatermark(ctx, shadowPadding, shadowPadding, contentWidth, contentHeight, settings.watermarkText);
        }

        // Convert to data URL
        return canvas.toDataURL('image/png');
    }

    private highlightCode(code: string, language: string, theme: any): string {
        try {
            if (language === 'plaintext') {
                return code;
            }
            const result = hljs.highlight(code, { language });
            return result.value;
        } catch (error) {
            return code;
        }
    }

    private renderLine(ctx: any, line: string, x: number, y: number, theme: any) {
        // Simple rendering - in production, parse highlighted HTML
        ctx.fillText(line, x, y);
    }

    private renderBackground(
        ctx: any,
        x: number,
        y: number,
        width: number,
        height: number,
        background: any,
        borderRadius: number
    ) {
        this.roundRect(ctx, x, y, width, height, borderRadius);

        if (background.type === 'solid') {
            ctx.fillStyle = background.color;
            ctx.fill();
        } else if (background.type === 'gradient') {
            const gradient = ctx.createLinearGradient(x, y, x + width, y + height);
            gradient.addColorStop(0, background.start);
            gradient.addColorStop(1, background.end);
            ctx.fillStyle = gradient;
            ctx.fill();
        } else if (background.type === 'transparent') {
            // No fill for transparent
        }
    }

    private renderWindowChrome(
        ctx: any,
        x: number,
        y: number,
        width: number,
        height: number,
        style: string,
        isDark: boolean,
        borderRadius: number
    ) {
        const bgColor = isDark ? '#2D2D2D' : '#F5F5F5';

        // Draw chrome background
        ctx.fillStyle = bgColor;
        this.roundRect(ctx, x, y, width, height, borderRadius, true); // Only top corners
        ctx.fill();

        // Traffic lights for macOS
        if (style === 'macos') {
            const buttonY = y + height / 2;
            const leftMargin = x + 12;

            // Red
            ctx.fillStyle = '#FF5F57';
            ctx.beginPath();
            ctx.arc(leftMargin, buttonY, 6, 0, Math.PI * 2);
            ctx.fill();

            // Yellow
            ctx.fillStyle = '#FFBD2E';
            ctx.beginPath();
            ctx.arc(leftMargin + 20, buttonY, 6, 0, Math.PI * 2);
            ctx.fill();

            // Green
            ctx.fillStyle = '#28CA42';
            ctx.beginPath();
            ctx.arc(leftMargin + 40, buttonY, 6, 0, Math.PI * 2);
            ctx.fill();
        }
    }

    private renderShadow(
        ctx: any,
        x: number,
        y: number,
        width: number,
        height: number,
        shadow: any,
        borderRadius: number
    ) {
        ctx.shadowColor = `rgba(0, 0, 0, ${shadow.opacity})`;
        ctx.shadowBlur = shadow.blur;
        ctx.shadowOffsetY = shadow.offsetY;

        // Draw a temporary shape to create shadow
        ctx.fillStyle = '#000';
        this.roundRect(ctx, x, y, width, height, borderRadius);
        ctx.fill();

        // Reset shadow
        ctx.shadowColor = 'transparent';
        ctx.shadowBlur = 0;
        ctx.shadowOffsetY = 0;
    }

    private renderWatermark(
        ctx: any,
        x: number,
        y: number,
        width: number,
        height: number,
        text: string
    ) {
        ctx.font = '12px Arial';
        ctx.fillStyle = 'rgba(255, 255, 255, 0.4)';
        ctx.textAlign = 'right';
        ctx.fillText(text, x + width - 16, y + height - 16);
        ctx.textAlign = 'left';
    }

    private roundRect(
        ctx: any,
        x: number,
        y: number,
        width: number,
        height: number,
        radius: number,
        topOnly: boolean = false
    ) {
        ctx.beginPath();
        ctx.moveTo(x + radius, y);
        ctx.lineTo(x + width - radius, y);
        ctx.quadraticCurveTo(x + width, y, x + width, y + radius);

        if (topOnly) {
            ctx.lineTo(x + width, y + height);
            ctx.lineTo(x, y + height);
        } else {
            ctx.lineTo(x + width, y + height - radius);
            ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
            ctx.lineTo(x + radius, y + height);
            ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
        }

        ctx.lineTo(x, y + radius);
        ctx.quadraticCurveTo(x, y, x + radius, y);
        ctx.closePath();
    }

    private getChromeHeight(style: string): number {
        switch (style) {
            case 'none': return 0;
            case 'macos': return 28;
            case 'browser': return 40;
            case 'vscode': return 35;
            case 'terminal': return 30;
            default: return 0;
        }
    }
}
