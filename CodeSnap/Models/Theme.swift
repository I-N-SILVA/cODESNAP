//
//  Theme.swift
//  CodeSnap
//
//  Syntax highlighting theme model
//

import Foundation
import SwiftUI

struct Theme: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var displayName: String
    var isDark: Bool
    var isBuiltIn: Bool
    var colors: ThemeColors

    init(
        id: UUID = UUID(),
        name: String,
        displayName: String,
        isDark: Bool,
        isBuiltIn: Bool = false,
        colors: ThemeColors
    ) {
        self.id = id
        self.name = name
        self.displayName = displayName
        self.isDark = isDark
        self.isBuiltIn = isBuiltIn
        self.colors = colors
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Theme, rhs: Theme) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Theme Colors

struct ThemeColors: Codable, Hashable {
    var background: String      // Editor background
    var foreground: String      // Default text color
    var comment: String         // Comments
    var keyword: String         // Keywords (if, let, var, etc)
    var string: String          // String literals
    var number: String          // Number literals
    var function: String        // Function names
    var variable: String        // Variable names
    var type: String            // Type names
    var constant: String        // Constants
    var `operator`: String      // Operators (+, -, *, etc)
    var punctuation: String     // Brackets, commas, etc
    var property: String        // Object properties
    var tag: String             // HTML/XML tags
    var attribute: String       // HTML/XML attributes

    init(
        background: String,
        foreground: String,
        comment: String,
        keyword: String,
        string: String,
        number: String,
        function: String,
        variable: String,
        type: String,
        constant: String,
        operator: String,
        punctuation: String,
        property: String,
        tag: String,
        attribute: String
    ) {
        self.background = background
        self.foreground = foreground
        self.comment = comment
        self.keyword = keyword
        self.string = string
        self.number = number
        self.function = function
        self.variable = variable
        self.type = type
        self.constant = constant
        self.operator = `operator`
        self.punctuation = punctuation
        self.property = property
        self.tag = tag
        self.attribute = attribute
    }

    // Convert hex colors to SwiftUI Colors
    var backgroundcolor: Color { Color(hex: background) }
    var foregroundColor: Color { Color(hex: foreground) }
    var commentColor: Color { Color(hex: comment) }
    var keywordColor: Color { Color(hex: keyword) }
    var stringColor: Color { Color(hex: string) }
    var numberColor: Color { Color(hex: number) }
    var functionColor: Color { Color(hex: function) }
    var variableColor: Color { Color(hex: variable) }
    var typeColor: Color { Color(hex: type) }
    var constantColor: Color { Color(hex: constant) }
    var operatorColor: Color { Color(hex: `operator`) }
    var punctuationColor: Color { Color(hex: punctuation) }
    var propertyColor: Color { Color(hex: property) }
    var tagColor: Color { Color(hex: tag) }
    var attributeColor: Color { Color(hex: attribute) }
}

// MARK: - Built-in Themes

extension Theme {
    // GitHub Light
    static let githubLight = Theme(
        name: "github-light",
        displayName: "GitHub Light",
        isDark: false,
        isBuiltIn: true,
        colors: ThemeColors(
            background: "#ffffff",
            foreground: "#24292e",
            comment: "#6a737d",
            keyword: "#d73a49",
            string: "#032f62",
            number: "#005cc5",
            function: "#6f42c1",
            variable: "#24292e",
            type: "#6f42c1",
            constant: "#005cc5",
            operator: "#d73a49",
            punctuation: "#24292e",
            property: "#005cc5",
            tag: "#22863a",
            attribute: "#6f42c1"
        )
    )

    // GitHub Dark
    static let githubDark = Theme(
        name: "github-dark",
        displayName: "GitHub Dark",
        isDark: true,
        isBuiltIn: true,
        colors: ThemeColors(
            background: "#0d1117",
            foreground: "#c9d1d9",
            comment: "#8b949e",
            keyword: "#ff7b72",
            string: "#a5d6ff",
            number: "#79c0ff",
            function: "#d2a8ff",
            variable: "#c9d1d9",
            type: "#d2a8ff",
            constant: "#79c0ff",
            operator: "#ff7b72",
            punctuation: "#c9d1d9",
            property: "#79c0ff",
            tag: "#7ee787",
            attribute: "#d2a8ff"
        )
    )

    // Dracula
    static let dracula = Theme(
        name: "dracula",
        displayName: "Dracula",
        isDark: true,
        isBuiltIn: true,
        colors: ThemeColors(
            background: "#282a36",
            foreground: "#f8f8f2",
            comment: "#6272a4",
            keyword: "#ff79c6",
            string: "#f1fa8c",
            number: "#bd93f9",
            function: "#50fa7b",
            variable: "#f8f8f2",
            type: "#8be9fd",
            constant: "#bd93f9",
            operator: "#ff79c6",
            punctuation: "#f8f8f2",
            property: "#50fa7b",
            tag: "#ff79c6",
            attribute: "#50fa7b"
        )
    )

    // Nord
    static let nord = Theme(
        name: "nord",
        displayName: "Nord",
        isDark: true,
        isBuiltIn: true,
        colors: ThemeColors(
            background: "#2e3440",
            foreground: "#d8dee9",
            comment: "#616e88",
            keyword: "#81a1c1",
            string: "#a3be8c",
            number: "#b48ead",
            function: "#88c0d0",
            variable: "#d8dee9",
            type: "#8fbcbb",
            constant: "#b48ead",
            operator: "#81a1c1",
            punctuation: "#d8dee9",
            property: "#88c0d0",
            tag: "#81a1c1",
            attribute: "#8fbcbb"
        )
    )

    // Tokyo Night
    static let tokyoNight = Theme(
        name: "tokyo-night",
        displayName: "Tokyo Night",
        isDark: true,
        isBuiltIn: true,
        colors: ThemeColors(
            background: "#1a1b26",
            foreground: "#a9b1d6",
            comment: "#565f89",
            keyword: "#bb9af7",
            string: "#9ece6a",
            number: "#ff9e64",
            function: "#7aa2f7",
            variable: "#a9b1d6",
            type: "#2ac3de",
            constant: "#ff9e64",
            operator: "#bb9af7",
            punctuation: "#a9b1d6",
            property: "#7aa2f7",
            tag: "#f7768e",
            attribute: "#bb9af7"
        )
    )

    // One Dark
    static let oneDark = Theme(
        name: "one-dark",
        displayName: "One Dark",
        isDark: true,
        isBuiltIn: true,
        colors: ThemeColors(
            background: "#282c34",
            foreground: "#abb2bf",
            comment: "#5c6370",
            keyword: "#c678dd",
            string: "#98c379",
            number: "#d19a66",
            function: "#61afef",
            variable: "#abb2bf",
            type: "#e5c07b",
            constant: "#d19a66",
            operator: "#c678dd",
            punctuation: "#abb2bf",
            property: "#61afef",
            tag: "#e06c75",
            attribute: "#d19a66"
        )
    )

    // Monokai Pro
    static let monokaiPro = Theme(
        name: "monokai-pro",
        displayName: "Monokai Pro",
        isDark: true,
        isBuiltIn: true,
        colors: ThemeColors(
            background: "#2d2a2e",
            foreground: "#fcfcfa",
            comment: "#727072",
            keyword: "#ff6188",
            string: "#ffd866",
            number: "#ab9df2",
            function: "#a9dc76",
            variable: "#fcfcfa",
            type: "#78dce8",
            constant: "#ab9df2",
            operator: "#ff6188",
            punctuation: "#fcfcfa",
            property: "#a9dc76",
            tag: "#ff6188",
            attribute: "#ffd866"
        )
    )

    // All built-in themes
    static let builtInThemes: [Theme] = [
        .githubLight,
        .githubDark,
        .dracula,
        .nord,
        .tokyoNight,
        .oneDark,
        .monokaiPro
    ]
}
