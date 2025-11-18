//
//  LanguageDetector.swift
//  CodeSnap
//
//  Automatically detect programming language from code
//

import Foundation

class LanguageDetector {
    static let shared = LanguageDetector()

    private init() {}

    // MARK: - Main Detection Method

    func detect(code: String) -> String {
        // 1. Check for shebang
        if let shebangLanguage = detectFromShebang(code) {
            return shebangLanguage
        }

        // 2. Check for unique syntax patterns
        if let patternLanguage = detectFromPatterns(code) {
            return patternLanguage
        }

        // 3. Check for language-specific keywords
        if let keywordLanguage = detectFromKeywords(code) {
            return keywordLanguage
        }

        // 4. Fallback to plaintext
        return "plaintext"
    }

    // Check if text looks like code
    func looksLikeCode(_ text: String) -> Bool {
        // Code characteristics:
        // - Contains common code symbols
        // - Has indentation
        // - Contains keywords
        // - Reasonable length

        guard text.count > 10 else { return false }

        let codeIndicators = [
            text.contains("{") && text.contains("}"),
            text.contains("(") && text.contains(")"),
            text.contains("function"),
            text.contains("const") || text.contains("let") || text.contains("var"),
            text.contains("def "),
            text.contains("class "),
            text.contains("import "),
            text.contains("=>"),
            text.contains("//") || text.contains("/*"),
            text.contains(";"),
            text.contains("==") || text.contains("==="),
        ]

        let score = codeIndicators.filter { $0 }.count
        return score >= 2
    }

    // MARK: - Detection Methods

    private func detectFromShebang(_ code: String) -> String? {
        guard code.hasPrefix("#!") else { return nil }

        let firstLine = code.components(separatedBy: .newlines).first ?? ""

        if firstLine.contains("python") { return "python" }
        if firstLine.contains("bash") || firstLine.contains("sh") { return "bash" }
        if firstLine.contains("node") { return "javascript" }
        if firstLine.contains("ruby") { return "ruby" }
        if firstLine.contains("perl") { return "perl" }
        if firstLine.contains("php") { return "php" }

        return nil
    }

    private func detectFromPatterns(_ code: String) -> String? {
        // Swift: func with ->
        if code.contains("func ") && code.contains(" -> ") && code.contains("{") {
            return "swift"
        }

        // Rust: fn with ->
        if code.contains("fn ") && code.contains(" -> ") {
            return "rust"
        }

        // Go: func with () type
        if code.contains("package ") && code.contains("func ") {
            return "go"
        }

        // Python: def with :
        if code.contains("def ") && code.contains(":") {
            if code.contains("    ") || code.contains("\t") { // Check for indentation
                return "python"
            }
        }

        // TypeScript: interface or type definitions
        if code.contains("interface ") || (code.contains("type ") && code.contains(" = ")) {
            if code.contains(": string") || code.contains(": number") {
                return "typescript"
            }
        }

        // JSX/TSX: Contains JSX syntax
        if code.contains("<") && code.contains(">") && code.contains("/>") {
            if code.contains("const ") || code.contains("function ") {
                if code.contains(": React") || code.contains("useState") {
                    return "tsx"
                }
                return "jsx"
            }
        }

        // HTML: DOCTYPE or common tags
        if code.contains("<!DOCTYPE") || code.contains("<html") {
            return "html"
        }

        // CSS: Selectors and properties
        if code.contains("{") && code.contains("}") && code.contains(":") && code.contains(";") {
            if code.contains("color") || code.contains("margin") || code.contains("padding") {
                return "css"
            }
        }

        // SQL: SELECT, INSERT, UPDATE, etc.
        let sqlKeywords = ["SELECT ", "INSERT ", "UPDATE ", "DELETE ", "CREATE TABLE", "FROM ", "WHERE "]
        if sqlKeywords.contains(where: { code.uppercased().contains($0) }) {
            return "sql"
        }

        // JSON: Starts with { or [
        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)
        if (trimmed.hasPrefix("{") && trimmed.hasSuffix("}")) ||
           (trimmed.hasPrefix("[") && trimmed.hasSuffix("]")) {
            if code.contains("\"") && code.contains(":") {
                return "json"
            }
        }

        // YAML: Starts with --- or has key: value
        if code.hasPrefix("---") || (code.contains(":") && !code.contains("{") && !code.contains(";")) {
            return "yaml"
        }

        // Markdown: Has # headers or markdown syntax
        if code.contains("# ") || code.contains("## ") || code.contains("```") {
            return "markdown"
        }

        return nil
    }

    private func detectFromKeywords(_ code: String) -> String? {
        let keywords: [String: [String]] = [
            "javascript": ["const ", "let ", "var ", "=>", "function ", "console.log"],
            "typescript": ["interface ", "type ", ": string", ": number", "as ", "export "],
            "python": ["def ", "import ", "from ", "__init__", "self", "elif "],
            "java": ["public class", "private ", "public ", "void ", "static ", "new "],
            "kotlin": ["fun ", "val ", "var ", "data class", "companion object"],
            "csharp": ["using ", "namespace ", "class ", "public ", "private ", "void "],
            "cpp": ["#include", "std::", "cout", "cin", "nullptr"],
            "c": ["#include", "int main", "printf", "scanf", "malloc"],
            "go": ["package ", "func ", ":=", "make(", "chan ", "goroutine"],
            "rust": ["fn ", "let mut", "impl ", "pub ", "use ", "match "],
            "swift": ["func ", "var ", "let ", "class ", "struct ", "extension "],
            "ruby": ["def ", "end", "do ", "require ", "class ", "module "],
            "php": ["<?php", "function ", "$", "echo ", "require ", "namespace "],
            "html": ["<html", "<div", "<p", "<head", "<body", "<!DOCTYPE"],
            "css": ["@media", "@import", "display:", "position:", "flex", "grid"],
            "scss": ["@mixin", "@include", "@extend", "@import", "$", "&"],
            "bash": ["#!/bin/bash", "echo ", "if [", "then", "fi", "function "],
            "shell": ["#!/bin/sh", "echo ", "export ", "source ", "alias "],
            "sql": ["SELECT ", "FROM ", "WHERE ", "INSERT ", "UPDATE ", "JOIN "],
            "dart": ["class ", "void ", "final ", "const ", "var ", "Widget "],
            "lua": ["function ", "local ", "then", "end", "require "],
            "r": ["<-", "function(", "library(", "data.frame", "ggplot"],
            "scala": ["object ", "def ", "val ", "var ", "class ", "trait "],
            "elixir": ["defmodule ", "def ", "do", "end", "|>"],
            "haskell": [" :: ", "where", "let ", "in ", "data ", "type "],
        ]

        var scores: [String: Int] = [:]

        for (language, words) in keywords {
            let score = words.filter { code.contains($0) }.count
            if score > 0 {
                scores[language] = score
            }
        }

        // Return language with highest score
        if let bestMatch = scores.max(by: { $0.value < $1.value }) {
            if bestMatch.value >= 2 { // Require at least 2 keyword matches
                return bestMatch.key
            }
        }

        return nil
    }

    // MARK: - Supported Languages

    func getAllSupportedLanguages() -> [String] {
        return Constants.Languages.supported.sorted()
    }

    func getDisplayName(for language: String) -> String {
        // Convert language ID to display name
        let displayNames: [String: String] = [
            "javascript": "JavaScript",
            "typescript": "TypeScript",
            "jsx": "React (JSX)",
            "tsx": "React (TSX)",
            "python": "Python",
            "java": "Java",
            "kotlin": "Kotlin",
            "c": "C",
            "cpp": "C++",
            "csharp": "C#",
            "go": "Go",
            "rust": "Rust",
            "swift": "Swift",
            "ruby": "Ruby",
            "php": "PHP",
            "html": "HTML",
            "css": "CSS",
            "scss": "SCSS",
            "sass": "Sass",
            "sql": "SQL",
            "bash": "Bash",
            "shell": "Shell",
            "powershell": "PowerShell",
            "yaml": "YAML",
            "json": "JSON",
            "xml": "XML",
            "markdown": "Markdown",
            "plaintext": "Plain Text"
        ]

        return displayNames[language] ?? language.capitalized
    }

    func getIcon(for language: String) -> String {
        // Return SF Symbol name for language
        let icons: [String: String] = [
            "javascript": "js.square",
            "typescript": "ts.square",
            "python": "snake",
            "swift": "swift",
            "html": "globe",
            "css": "paintbrush",
            "json": "curlybraces",
            "markdown": "doc.text",
            "bash": "terminal",
            "shell": "terminal.fill"
        ]

        return icons[language] ?? "doc.text"
    }
}
