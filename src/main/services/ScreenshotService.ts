// Screenshot service - handles screenshot creation and management
export class ScreenshotService {
    detectLanguage(code: string): string {
        // JavaScript / TypeScript
        if (code.includes('function') || code.includes('const') || code.includes('=>')) {
            if (code.includes('interface') || code.includes(': string') || code.includes(': number')) {
                return 'typescript';
            }
            if (code.includes('<') && code.includes('/>') && code.includes('return')) {
                return 'jsx';
            }
            return 'javascript';
        }

        // Python
        if (code.includes('def ') && code.includes(':')) {
            if (code.match(/^\s{4}/m) || code.includes('\t')) {
                return 'python';
            }
        }

        // Swift
        if (code.includes('func ') && code.includes(' -> ')) {
            return 'swift';
        }

        // Go
        if (code.includes('package ') && code.includes('func ')) {
            return 'go';
        }

        // Rust
        if (code.includes('fn ') && code.includes(' -> ')) {
            return 'rust';
        }

        // HTML
        if (code.includes('<!DOCTYPE') || code.includes('<html')) {
            return 'html';
        }

        // CSS
        if (code.includes('{') && code.includes('}') && code.includes(':') && code.includes(';')) {
            if (code.includes('color') || code.includes('margin') || code.includes('padding')) {
                return 'css';
            }
        }

        // JSON
        const trimmed = code.trim();
        if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
            (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
            if (code.includes('"') && code.includes(':')) {
                return 'json';
            }
        }

        return 'plaintext';
    }

    looksLikeCode(text: string): boolean {
        if (text.length < 10) return false;

        const codeIndicators = [
            text.includes('{') && text.includes('}'),
            text.includes('(') && text.includes(')'),
            text.includes('function'),
            text.includes('const') || text.includes('let') || text.includes('var'),
            text.includes('def '),
            text.includes('class '),
            text.includes('import '),
            text.includes('=>'),
            text.includes('//') || text.includes('/*'),
            text.includes(';'),
            text.includes('==') || text.includes('===')
        ];

        const score = codeIndicators.filter(Boolean).length;
        return score >= 2;
    }
}
