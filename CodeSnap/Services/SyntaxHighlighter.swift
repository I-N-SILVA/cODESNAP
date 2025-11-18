//
//  SyntaxHighlighter.swift
//  CodeSnap
//
//  Syntax highlighting service (Swift-native implementation)
//

import Foundation
import AppKit

class SyntaxHighlighter {
    static let shared = SyntaxHighlighter()

    private init() {}

    // MARK: - Main Highlighting Method

    func highlight(code: String, language: String, theme: Theme, fontSize: CGFloat, fontFamily: String, lineHeight: CGFloat) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: code)

        // Base text attributes
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = (fontSize * lineHeight) - fontSize
        paragraphStyle.lineBreakMode = .byCharWrapping

        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont(name: fontFamily, size: fontSize) ?? NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular),
            .foregroundColor: NSColor(hex: theme.colors.foreground) ?? NSColor.white,
            .paragraphStyle: paragraphStyle
        ]

        attributed.addAttributes(baseAttributes, range: NSRange(location: 0, length: attributed.length))

        // Apply syntax highlighting based on language
        switch language.lowercased() {
        case "javascript", "typescript", "jsx", "tsx":
            highlightJavaScript(attributed, theme: theme)
        case "python":
            highlightPython(attributed, theme: theme)
        case "swift":
            highlightSwift(attributed, theme: theme)
        case "go":
            highlightGo(attributed, theme: theme)
        case "rust":
            highlightRust(attributed, theme: theme)
        case "html":
            highlightHTML(attributed, theme: theme)
        case "css", "scss":
            highlightCSS(attributed, theme: theme)
        case "json":
            highlightJSON(attributed, theme: theme)
        default:
            highlightGeneric(attributed, theme: theme)
        }

        return attributed
    }

    // MARK: - Language-Specific Highlighters

    private func highlightJavaScript(_ text: NSMutableAttributedString, theme: Theme) {
        let string = text.string

        // Keywords
        let keywords = ["const", "let", "var", "function", "if", "else", "for", "while", "return", "class", "extends", "import", "export", "default", "async", "await", "try", "catch", "throw", "new", "this", "super", "static", "get", "set", "typeof", "instanceof", "in", "of", "break", "continue", "switch", "case", "do", "yield"]
        highlightPatterns(text, patterns: keywords.map { "\\b\($0)\\b" }, color: theme.colors.keyword)

        // Strings
        highlightPattern(text, pattern: "\"(?:[^\"\\\\]|\\\\.)*\"", color: theme.colors.string)
        highlightPattern(text, pattern: "'(?:[^'\\\\]|\\\\.)*'", color: theme.colors.string)
        highlightPattern(text, pattern: "`(?:[^`\\\\]|\\\\.)*`", color: theme.colors.string)

        // Comments
        highlightPattern(text, pattern: "//.*$", color: theme.colors.comment, multiline: true)
        highlightPattern(text, pattern: "/\\*[\\s\\S]*?\\*/", color: theme.colors.comment)

        // Numbers
        highlightPattern(text, pattern: "\\b\\d+\\.?\\d*\\b", color: theme.colors.number)

        // Functions (word followed by parenthesis)
        highlightPattern(text, pattern: "\\b([a-zA-Z_][a-zA-Z0-9_]*)(?=\\s*\\()", color: theme.colors.function)

        // Properties (after dot)
        highlightPattern(text, pattern: "\\.([a-zA-Z_][a-zA-Z0-9_]*)", color: theme.colors.property, captureGroup: 1)

        // Constants (all caps)
        highlightPattern(text, pattern: "\\b[A-Z_][A-Z0-9_]*\\b", color: theme.colors.constant)
    }

    private func highlightPython(_ text: NSMutableAttributedString, theme: Theme) {
        // Keywords
        let keywords = ["def", "class", "if", "elif", "else", "for", "while", "return", "import", "from", "as", "try", "except", "finally", "with", "lambda", "yield", "async", "await", "pass", "break", "continue", "global", "nonlocal", "assert", "raise", "in", "is", "not", "and", "or"]
        highlightPatterns(text, patterns: keywords.map { "\\b\($0)\\b" }, color: theme.colors.keyword)

        // Strings
        highlightPattern(text, pattern: "\"\"\"[\\s\\S]*?\"\"\"", color: theme.colors.string)
        highlightPattern(text, pattern: "'''[\\s\\S]*?'''", color: theme.colors.string)
        highlightPattern(text, pattern: "\"(?:[^\"\\\\]|\\\\.)*\"", color: theme.colors.string)
        highlightPattern(text, pattern: "'(?:[^'\\\\]|\\\\.)*'", color: theme.colors.string)

        // Comments
        highlightPattern(text, pattern: "#.*$", color: theme.colors.comment, multiline: true)

        // Numbers
        highlightPattern(text, pattern: "\\b\\d+\\.?\\d*\\b", color: theme.colors.number)

        // Functions/Methods
        highlightPattern(text, pattern: "\\bdef\\s+([a-zA-Z_][a-zA-Z0-9_]*)", color: theme.colors.function, captureGroup: 1)

        // Class names
        highlightPattern(text, pattern: "\\bclass\\s+([a-zA-Z_][a-zA-Z0-9_]*)", color: theme.colors.type, captureGroup: 1)

        // self
        highlightPattern(text, pattern: "\\bself\\b", color: theme.colors.keyword)
    }

    private func highlightSwift(_ text: NSMutableAttributedString, theme: Theme) {
        // Keywords
        let keywords = ["func", "var", "let", "class", "struct", "enum", "protocol", "extension", "if", "else", "guard", "switch", "case", "for", "while", "return", "import", "public", "private", "internal", "static", "final", "override", "init", "self", "super", "try", "catch", "throw", "throws", "async", "await", "actor", "some", "any"]
        highlightPatterns(text, patterns: keywords.map { "\\b\($0)\\b" }, color: theme.colors.keyword)

        // Strings
        highlightPattern(text, pattern: "\"(?:[^\"\\\\]|\\\\.)*\"", color: theme.colors.string)

        // Comments
        highlightPattern(text, pattern: "//.*$", color: theme.colors.comment, multiline: true)
        highlightPattern(text, pattern: "/\\*[\\s\\S]*?\\*/", color: theme.colors.comment)

        // Numbers
        highlightPattern(text, pattern: "\\b\\d+\\.?\\d*\\b", color: theme.colors.number)

        // Types (capitalized words)
        highlightPattern(text, pattern: "\\b[A-Z][a-zA-Z0-9]*\\b", color: theme.colors.type)

        // Functions
        highlightPattern(text, pattern: "\\bfunc\\s+([a-zA-Z_][a-zA-Z0-9_]*)", color: theme.colors.function, captureGroup: 1)
    }

    private func highlightGo(_ text: NSMutableAttributedString, theme: Theme) {
        // Keywords
        let keywords = ["func", "var", "const", "type", "struct", "interface", "if", "else", "for", "range", "return", "package", "import", "go", "defer", "select", "chan", "map", "make", "new", "break", "continue", "switch", "case", "default", "fallthrough"]
        highlightPatterns(text, patterns: keywords.map { "\\b\($0)\\b" }, color: theme.colors.keyword)

        // Strings
        highlightPattern(text, pattern: "\"(?:[^\"\\\\]|\\\\.)*\"", color: theme.colors.string)
        highlightPattern(text, pattern: "`[^`]*`", color: theme.colors.string)

        // Comments
        highlightPattern(text, pattern: "//.*$", color: theme.colors.comment, multiline: true)
        highlightPattern(text, pattern: "/\\*[\\s\\S]*?\\*/", color: theme.colors.comment)

        // Numbers
        highlightPattern(text, pattern: "\\b\\d+\\.?\\d*\\b", color: theme.colors.number)
    }

    private func highlightRust(_ text: NSMutableAttributedString, theme: Theme) {
        // Keywords
        let keywords = ["fn", "let", "mut", "const", "static", "struct", "enum", "trait", "impl", "if", "else", "match", "for", "while", "loop", "return", "use", "pub", "mod", "crate", "self", "super", "async", "await", "move", "ref", "type", "where", "unsafe", "extern"]
        highlightPatterns(text, patterns: keywords.map { "\\b\($0)\\b" }, color: theme.colors.keyword)

        // Strings
        highlightPattern(text, pattern: "\"(?:[^\"\\\\]|\\\\.)*\"", color: theme.colors.string)

        // Comments
        highlightPattern(text, pattern: "//.*$", color: theme.colors.comment, multiline: true)
        highlightPattern(text, pattern: "/\\*[\\s\\S]*?\\*/", color: theme.colors.comment)

        // Numbers
        highlightPattern(text, pattern: "\\b\\d+\\.?\\d*\\b", color: theme.colors.number)

        // Macros
        highlightPattern(text, pattern: "\\b[a-z_][a-z0-9_]*!", color: theme.colors.function)
    }

    private func highlightHTML(_ text: NSMutableAttributedString, theme: Theme) {
        // Tags
        highlightPattern(text, pattern: "</?[a-zA-Z][a-zA-Z0-9]*", color: theme.colors.tag)
        highlightPattern(text, pattern: "/>|>", color: theme.colors.tag)

        // Attributes
        highlightPattern(text, pattern: "\\b[a-zA-Z-]+(?==)", color: theme.colors.attribute)

        // Strings (attribute values)
        highlightPattern(text, pattern: "\"[^\"]*\"", color: theme.colors.string)
        highlightPattern(text, pattern: "'[^']*'", color: theme.colors.string)

        // Comments
        highlightPattern(text, pattern: "<!--[\\s\\S]*?-->", color: theme.colors.comment)
    }

    private func highlightCSS(_ text: NSMutableAttributedString, theme: Theme) {
        // Selectors
        highlightPattern(text, pattern: "^\\s*[.#]?[a-zA-Z][a-zA-Z0-9-]*", color: theme.colors.tag, multiline: true)

        // Properties
        highlightPattern(text, pattern: "\\b[a-z-]+(?=:)", color: theme.colors.property)

        // Values
        highlightPattern(text, pattern: ":\\s*([^;]+)", color: theme.colors.string, captureGroup: 1)

        // Numbers with units
        highlightPattern(text, pattern: "\\b\\d+\\.?\\d*(px|em|rem|%|vh|vw)?\\b", color: theme.colors.number)

        // Comments
        highlightPattern(text, pattern: "/\\*[\\s\\S]*?\\*/", color: theme.colors.comment)
    }

    private func highlightJSON(_ text: NSMutableAttributedString, theme: Theme) {
        // Keys
        highlightPattern(text, pattern: "\"([^\"]+)\"(?=\\s*:)", color: theme.colors.property)

        // String values
        highlightPattern(text, pattern: ":\\s*\"([^\"]+)\"", color: theme.colors.string)

        // Numbers
        highlightPattern(text, pattern: "\\b\\d+\\.?\\d*\\b", color: theme.colors.number)

        // Booleans and null
        highlightPattern(text, pattern: "\\b(true|false|null)\\b", color: theme.colors.keyword)
    }

    private func highlightGeneric(_ text: NSMutableAttributedString, theme: Theme) {
        // Common keywords
        let keywords = ["if", "else", "for", "while", "return", "function", "class", "var", "let", "const", "import", "export", "public", "private", "static"]
        highlightPatterns(text, patterns: keywords.map { "\\b\($0)\\b" }, color: theme.colors.keyword)

        // Strings
        highlightPattern(text, pattern: "\"(?:[^\"\\\\]|\\\\.)*\"", color: theme.colors.string)
        highlightPattern(text, pattern: "'(?:[^'\\\\]|\\\\.)*'", color: theme.colors.string)

        // Comments (C-style)
        highlightPattern(text, pattern: "//.*$", color: theme.colors.comment, multiline: true)
        highlightPattern(text, pattern: "/\\*[\\s\\S]*?\\*/", color: theme.colors.comment)

        // Numbers
        highlightPattern(text, pattern: "\\b\\d+\\.?\\d*\\b", color: theme.colors.number)
    }

    // MARK: - Helper Methods

    private func highlightPattern(_ text: NSMutableAttributedString, pattern: String, color: String, captureGroup: Int = 0, multiline: Bool = false) {
        guard let regex = try? NSRegularExpression(
            pattern: pattern,
            options: multiline ? [.anchorsMatchLines] : []
        ) else { return }

        let range = NSRange(location: 0, length: text.length)
        let matches = regex.matches(in: text.string, options: [], range: range)

        for match in matches {
            let matchRange = captureGroup < match.numberOfRanges ? match.range(at: captureGroup) : match.range
            if matchRange.location != NSNotFound {
                text.addAttribute(.foregroundColor, value: NSColor(hex: color) ?? NSColor.white, range: matchRange)
            }
        }
    }

    private func highlightPatterns(_ text: NSMutableAttributedString, patterns: [String], color: String) {
        for pattern in patterns {
            highlightPattern(text, pattern: pattern, color: color)
        }
    }
}

// MARK: - NSColor Hex Extension

extension NSColor {
    convenience init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(
            srgbRed: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
