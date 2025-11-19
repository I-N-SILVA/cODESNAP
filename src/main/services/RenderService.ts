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

    async render(screenshot: any, showWatermark: boolean = true, watermarkText: string = 'Created with CodeSnap'): Promise<string> {
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

        // Highlight code and get tokenized lines
        const highlightedLines = this.highlightCode(code, language, theme);

        // Calculate dimensions accurately using canvas measureText
        const lineHeight = fontSize * 1.5;
        const lines = code.split('\n');

        // Create temporary canvas to measure text
        const tempCanvas = createCanvas(100, 100);
        const tempCtx = tempCanvas.getContext('2d');
        tempCtx.font = `${fontSize}px "${fontFamily}", monospace`;

        // Measure widest line
        let maxWidth = 0;
        lines.forEach((line, index) => {
            let lineWidth = 0;
            if (showLineNumbers) {
                lineWidth += tempCtx.measureText(`${index + 1}`).width + 40;
            }
            const codeWidth = tempCtx.measureText(line).width;
            lineWidth += codeWidth;
            maxWidth = Math.max(maxWidth, lineWidth);
        });

        const textWidth = maxWidth;
        const textHeight = lines.length * lineHeight;

        const chromeHeight = this.getChromeHeight(windowStyle);
        const contentWidth = Math.max(textWidth + padding * 2, 400); // Minimum width
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
        highlightedLines.forEach((lineTokens, index) => {
            const x = shadowPadding + padding;

            // Line numbers
            if (showLineNumbers) {
                ctx.fillStyle = theme.colors.comment;
                const lineNum = `${index + 1}`;
                const lineNumWidth = ctx.measureText(lineNum).width;
                ctx.fillText(lineNum, x, y);
                ctx.fillStyle = theme.colors.foreground;
            }

            // Code with syntax highlighting
            const codeX = showLineNumbers ? x + 40 : x;
            this.renderLine(ctx, lineTokens, codeX, y);

            y += lineHeight;
        });

        // Render watermark if enabled
        if (showWatermark) {
            this.renderWatermark(ctx, shadowPadding, shadowPadding, contentWidth, contentHeight, watermarkText);
        }

        // Convert to data URL
        return canvas.toDataURL('image/png');
    }

    private highlightCode(code: string, language: string, theme: any): any[][] {
        try {
            if (language === 'plaintext' || language === 'auto') {
                return code.split('\n').map(line => [{ text: line, color: theme.colors.foreground }]);
            }

            const result = hljs.highlight(code, { language });
            return this.parseHighlightedHTML(result.value, theme);
        } catch (error) {
            // Fallback to plaintext if highlighting fails
            return code.split('\n').map(line => [{ text: line, color: theme.colors.foreground }]);
        }
    }

    private parseHighlightedHTML(html: string, theme: any): any[][] {
        const lines = html.split('\n');
        return lines.map(line => this.parseLineTokens(line, theme));
    }

    private parseLineTokens(html: string, theme: any): any[] {
        const tokens: any[] = [];
        const tokenRegex = /<span class="([^"]+)">([^<]*)<\/span>|([^<]+)/g;
        let match;

        while ((match = tokenRegex.exec(html)) !== null) {
            if (match[1]) {
                // Span with class
                const className = match[1];
                const text = this.decodeHTML(match[2]);
                const color = this.getColorForClass(className, theme);
                tokens.push({ text, color });
            } else if (match[3]) {
                // Plain text
                const text = this.decodeHTML(match[3]);
                tokens.push({ text, color: theme.colors.foreground });
            }
        }

        return tokens.length > 0 ? tokens : [{ text: '', color: theme.colors.foreground }];
    }

    private getColorForClass(className: string, theme: any): string {
        const colors = theme.colors;

        // Map hljs classes to theme colors
        if (className.includes('keyword')) return colors.keyword;
        if (className.includes('string')) return colors.string;
        if (className.includes('number')) return colors.number;
        if (className.includes('function') || className.includes('title')) return colors.function;
        if (className.includes('comment')) return colors.comment;
        if (className.includes('type') || className.includes('class')) return colors.type;
        if (className.includes('variable') || className.includes('params')) return colors.variable;
        if (className.includes('operator')) return colors.operator;
        if (className.includes('punctuation')) return colors.punctuation;
        if (className.includes('property') || className.includes('attr')) return colors.property;
        if (className.includes('tag') || className.includes('name')) return colors.tag;
        if (className.includes('constant') || className.includes('built_in') || className.includes('literal')) return colors.constant;

        return colors.foreground;
    }

    private decodeHTML(html: string): string {
        return html
            .replace(/&lt;/g, '<')
            .replace(/&gt;/g, '>')
            .replace(/&amp;/g, '&')
            .replace(/&quot;/g, '"')
            .replace(/&#39;/g, "'");
    }

    private renderLine(ctx: any, tokens: any[], x: number, y: number) {
        let currentX = x;

        for (const token of tokens) {
            ctx.fillStyle = token.color;
            ctx.fillText(token.text, currentX, y);
            currentX += ctx.measureText(token.text).width;
        }
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
