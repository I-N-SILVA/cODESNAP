//
//  ThemeManager.swift
//  CodeSnap
//
//  Manage themes and provide theme-related functionality
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var themes: [Theme] = []
    @Published var selectedTheme: Theme

    private let storage = StorageManager.shared

    private init() {
        // Start with default theme
        self.selectedTheme = Theme.githubDark
        loadThemes()
    }

    // MARK: - Theme Loading

    func loadThemes() {
        var allThemes: [Theme] = []

        // Add built-in themes
        allThemes.append(contentsOf: Theme.builtInThemes)

        // Load custom themes
        if let customThemes = try? storage.loadThemes() {
            allThemes.append(contentsOf: customThemes)
        }

        self.themes = allThemes.sorted { theme1, theme2 in
            // Built-in themes first
            if theme1.isBuiltIn && !theme2.isBuiltIn {
                return true
            }
            if !theme1.isBuiltIn && theme2.isBuiltIn {
                return false
            }
            // Then alphabetically
            return theme1.displayName < theme2.displayName
        }
    }

    // MARK: - Theme Selection

    func selectTheme(named name: String) {
        if let theme = themes.first(where: { $0.name == name }) {
            selectedTheme = theme
        }
    }

    func selectTheme(_ theme: Theme) {
        selectedTheme = theme
    }

    // MARK: - Theme Management

    func saveCustomTheme(_ theme: Theme) throws {
        var newTheme = theme
        newTheme.isBuiltIn = false

        try storage.saveTheme(newTheme)
        loadThemes()
    }

    func deleteTheme(_ theme: Theme) throws {
        guard !theme.isBuiltIn else {
            throw StorageError.cannotDeleteBuiltIn
        }

        try storage.deleteTheme(theme)
        loadThemes()
    }

    func duplicateTheme(_ theme: Theme, newName: String) -> Theme {
        Theme(
            name: newName.lowercased().replacingOccurrences(of: " ", with: "-"),
            displayName: newName,
            isDark: theme.isDark,
            isBuiltIn: false,
            colors: theme.colors
        )
    }

    // MARK: - Theme Utilities

    func getTheme(named name: String) -> Theme? {
        themes.first { $0.name == name }
    }

    func getLightThemes() -> [Theme] {
        themes.filter { !$0.isDark }
    }

    func getDarkThemes() -> [Theme] {
        themes.filter { $0.isDark }
    }

    func getBuiltInThemes() -> [Theme] {
        themes.filter { $0.isBuiltIn }
    }

    func getCustomThemes() -> [Theme] {
        themes.filter { !$0.isBuiltIn }
    }

    // MARK: - Import/Export

    func importThemeFromJSON(_ jsonString: String) throws -> Theme {
        let data = jsonString.data(using: .utf8)!
        let theme = try JSONDecoder().decode(Theme.self, from: data)
        return theme
    }

    func exportThemeToJSON(_ theme: Theme) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(theme)
        return String(data: data, encoding: .utf8)!
    }

    func importVSCodeTheme(from url: URL) throws -> Theme {
        // TODO: Parse VS Code theme JSON format
        // This is a complex task as VS Code themes have a different structure
        throw StorageError.notImplemented
    }

    // MARK: - Theme Preview

    func generatePreview(for theme: Theme, code: String = sampleCode) -> NSImage {
        // Generate a small preview image of the theme
        // This would use the rendering engine to create a thumbnail
        // For now, return a placeholder
        // TODO: Implement actual preview generation
        return NSImage(size: NSSize(width: 140, height: 100))
    }

    private static let sampleCode = """
    function hello() {
      const name = "World";
      console.log(`Hello, ${name}!`);
    }
    """
}

// MARK: - Theme Extensions

extension Theme {
    /// Generate a sample preview of this theme
    var previewCode: String {
        """
        function greet(name) {
          // Say hello
          return `Hello, ${name}!`;
        }
        """
    }

    /// Get SwiftUI color for a syntax element
    func color(for element: SyntaxElement) -> Color {
        switch element {
        case .background: return colors.backgroundcolor
        case .foreground: return colors.foregroundColor
        case .comment: return colors.commentColor
        case .keyword: return colors.keywordColor
        case .string: return colors.stringColor
        case .number: return colors.numberColor
        case .function: return colors.functionColor
        case .variable: return colors.variableColor
        case .type: return colors.typeColor
        case .constant: return colors.constantColor
        case .operator: return colors.operatorColor
        case .punctuation: return colors.punctuationColor
        case .property: return colors.propertyColor
        case .tag: return colors.tagColor
        case .attribute: return colors.attributeColor
        }
    }
}

enum SyntaxElement {
    case background, foreground, comment, keyword, string, number
    case function, variable, type, constant, `operator`, punctuation
    case property, tag, attribute
}
