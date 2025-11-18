//
//  Preset.swift
//  CodeSnap
//
//  Model for saved screenshot presets
//

import Foundation
import SwiftUI

struct Preset: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var emoji: String
    var theme: String
    var windowStyle: WindowStyle
    var backgroundColor: BackgroundStyle
    var fontSize: CGFloat
    var fontFamily: String
    var lineHeight: CGFloat
    var padding: CGFloat
    var shadow: ShadowConfig
    var exportSize: CGFloat
    var borderRadius: CGFloat
    var showLineNumbers: Bool
    var enableLigatures: Bool
    var hotkey: String?
    var isBuiltIn: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        emoji: String,
        theme: String,
        windowStyle: WindowStyle = .macos,
        backgroundColor: BackgroundStyle = .gradient("#667eea", "#764ba2"),
        fontSize: CGFloat = 16,
        fontFamily: String = "JetBrains Mono",
        lineHeight: CGFloat = 1.5,
        padding: CGFloat = 48,
        shadow: ShadowConfig = ShadowConfig(),
        exportSize: CGFloat = 2.0,
        borderRadius: CGFloat = 12,
        showLineNumbers: Bool = true,
        enableLigatures: Bool = true,
        hotkey: String? = nil,
        isBuiltIn: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.theme = theme
        self.windowStyle = windowStyle
        self.backgroundColor = backgroundColor
        self.fontSize = fontSize
        self.fontFamily = fontFamily
        self.lineHeight = lineHeight
        self.padding = padding
        self.shadow = shadow
        self.exportSize = exportSize
        self.borderRadius = borderRadius
        self.showLineNumbers = showLineNumbers
        self.enableLigatures = enableLigatures
        self.hotkey = hotkey
        self.isBuiltIn = isBuiltIn
        self.createdAt = createdAt
    }

    // MARK: - Methods

    func applyTo(screenshot: inout Screenshot) {
        screenshot.theme = theme
        screenshot.windowStyle = windowStyle
        screenshot.backgroundColor = backgroundColor
        screenshot.fontSize = fontSize
        screenshot.fontFamily = fontFamily
        screenshot.lineHeight = lineHeight
        screenshot.padding = padding
        screenshot.shadow = shadow
        screenshot.exportSize = exportSize
        screenshot.borderRadius = borderRadius
        screenshot.showLineNumbers = showLineNumbers
        screenshot.enableLigatures = enableLigatures
    }

    static func from(screenshot: Screenshot, name: String, emoji: String) -> Preset {
        Preset(
            name: name,
            emoji: emoji,
            theme: screenshot.theme,
            windowStyle: screenshot.windowStyle,
            backgroundColor: screenshot.backgroundColor,
            fontSize: screenshot.fontSize,
            fontFamily: screenshot.fontFamily,
            lineHeight: screenshot.lineHeight,
            padding: screenshot.padding,
            shadow: screenshot.shadow,
            exportSize: screenshot.exportSize,
            borderRadius: screenshot.borderRadius,
            showLineNumbers: screenshot.showLineNumbers,
            enableLigatures: screenshot.enableLigatures
        )
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Preset, rhs: Preset) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Built-in Presets

extension Preset {
    // Social Media - Optimized for Twitter/Instagram
    static let socialMedia = Preset(
        name: "Social Media",
        emoji: "📱",
        theme: "github-dark",
        windowStyle: .macos,
        backgroundColor: .gradient("#667eea", "#764ba2"),
        fontSize: 18,
        fontFamily: "JetBrains Mono",
        padding: 64,
        shadow: .large,
        exportSize: 2.0,
        hotkey: "⌘1",
        isBuiltIn: true
    )

    // Documentation - Clean and professional
    static let documentation = Preset(
        name: "Documentation",
        emoji: "📝",
        theme: "github-light",
        windowStyle: .none,
        backgroundColor: .solid("#ffffff"),
        fontSize: 14,
        fontFamily: "SF Mono",
        padding: 32,
        shadow: .small,
        exportSize: 2.0,
        hotkey: "⌘2",
        isBuiltIn: true
    )

    // Portfolio - Beautiful gradients
    static let portfolio = Preset(
        name: "Portfolio",
        emoji: "🎨",
        theme: "dracula",
        windowStyle: .vscode,
        backgroundColor: .gradient("#f12711", "#f5af19"),
        fontSize: 16,
        fontFamily: "Fira Code",
        padding: 56,
        shadow: .medium,
        exportSize: 3.0,
        borderRadius: 16,
        hotkey: "⌘3",
        isBuiltIn: true
    )

    // Dark Mode - Subtle and elegant
    static let darkMode = Preset(
        name: "Dark Mode",
        emoji: "🌙",
        theme: "tokyo-night",
        windowStyle: .macos,
        backgroundColor: .solid("#1a1b26"),
        fontSize: 16,
        fontFamily: "JetBrains Mono",
        padding: 48,
        shadow: .none,
        exportSize: 2.0,
        hotkey: "⌘4",
        isBuiltIn: true
    )

    // Light Mode - Bright and readable
    static let lightMode = Preset(
        name: "Light Mode",
        emoji: "☀️",
        theme: "github-light",
        windowStyle: .browser,
        backgroundColor: .solid("#f8f9fa"),
        fontSize: 16,
        fontFamily: "SF Mono",
        padding: 48,
        shadow: .medium,
        exportSize: 2.0,
        hotkey: "⌘5",
        isBuiltIn: true
    )

    // Minimal - Clean and simple
    static let minimal = Preset(
        name: "Minimal",
        emoji: "⚪",
        theme: "github-light",
        windowStyle: .none,
        backgroundColor: .transparent,
        fontSize: 14,
        fontFamily: "SF Mono",
        padding: 24,
        shadow: .none,
        exportSize: 2.0,
        showLineNumbers: false,
        isBuiltIn: true
    )

    // Terminal - Classic terminal look
    static let terminal = Preset(
        name: "Terminal",
        emoji: "💻",
        theme: "one-dark",
        windowStyle: .terminal,
        backgroundColor: .solid("#1e1e1e"),
        fontSize: 14,
        fontFamily: "Menlo",
        padding: 40,
        shadow: .small,
        exportSize: 2.0,
        isBuiltIn: true
    )

    // Neon - Vibrant and eye-catching
    static let neon = Preset(
        name: "Neon",
        emoji: "⚡",
        theme: "monokai-pro",
        windowStyle: .none,
        backgroundColor: .gradient("#6a3093", "#a044ff"),
        fontSize: 18,
        fontFamily: "Fira Code",
        padding: 60,
        shadow: .large,
        exportSize: 2.0,
        borderRadius: 20,
        isBuiltIn: true
    )

    // All built-in presets
    static let builtInPresets: [Preset] = [
        .socialMedia,
        .documentation,
        .portfolio,
        .darkMode,
        .lightMode,
        .minimal,
        .terminal,
        .neon
    ]
}
