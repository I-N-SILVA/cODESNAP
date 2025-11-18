//
//  Constants.swift
//  CodeSnap
//
//  App-wide constants and configuration
//

import Foundation
import SwiftUI

enum Constants {
    // MARK: - App Info
    static let appName = "CodeSnap"
    static let appVersion = "1.0.0"
    static let appBuildNumber = "1"
    static let appWebsite = "https://codesnap.app"
    static let supportEmail = "support@codesnap.app"
    static let twitterHandle = "@CodeSnapApp"

    // MARK: - Feature Flags
    static let enableProFeatures = false // Set to true for Pro version
    static let enableAnalytics = true
    static let enableCrashReporting = true

    // MARK: - UI Constants
    enum UI {
        // Menu Bar
        static let menuBarIconSize: CGFloat = 16
        static let menuWidth: CGFloat = 320
        static let menuMaxHeight: CGFloat = 420

        // Quick Preview Window
        static let previewMaxWidth: CGFloat = 800
        static let previewCornerRadius: CGFloat = 16
        static let previewShadowRadius: CGFloat = 24

        // Editor Window
        static let editorWidth: CGFloat = 1200
        static let editorHeight: CGFloat = 700
        static let editorMinWidth: CGFloat = 900
        static let editorMinHeight: CGFloat = 500
        static let settingsPanelWidth: CGFloat = 320

        // Library Window
        static let libraryWidth: CGFloat = 1000
        static let libraryHeight: CGFloat = 600
        static let thumbnailSize = CGSize(width: 180, height: 140)

        // Settings Window
        static let settingsWidth: CGFloat = 600
        static let settingsHeight: CGFloat = 500

        // Spacing
        static let spacingTight: CGFloat = 4
        static let spacingClose: CGFloat = 8
        static let spacingDefault: CGFloat = 12
        static let spacingComfortable: CGFloat = 16
        static let spacingLoose: CGFloat = 24
        static let spacingSpaciou: CGFloat = 32
        static let spacingExtra: CGFloat = 48

        // Animation Durations
        static let animationQuick: Double = 0.15
        static let animationNormal: Double = 0.3
        static let animationSlow: Double = 0.5
    }

    // MARK: - Rendering Constants
    enum Rendering {
        static let defaultFontSize: CGFloat = 16
        static let minFontSize: CGFloat = 12
        static let maxFontSize: CGFloat = 24

        static let defaultPadding: CGFloat = 48
        static let minPadding: CGFloat = 16
        static let maxPadding: CGFloat = 80

        static let defaultLineHeight: CGFloat = 1.5
        static let minLineHeight: CGFloat = 1.2
        static let maxLineHeight: CGFloat = 2.0

        static let defaultShadowSize: CGFloat = 40
        static let defaultShadowBlur: CGFloat = 60
        static let defaultShadowOpacity: CGFloat = 0.3
        static let defaultShadowOffset: CGFloat = 8

        static let maxCodeLines = 500
        static let warningCodeLines = 200
    }

    // MARK: - Export Constants
    enum Export {
        static let defaultFormat = ExportFormat.png
        static let defaultSize: CGFloat = 2.0 // 2x (Retina)
        static let jpegQuality: CGFloat = 0.9

        static let presetSizes: [String: CGFloat] = [
            "1x": 1.0,
            "2x (Retina)": 2.0,
            "3x": 3.0,
            "4x": 4.0
        ]

        static let socialMediaPresets: [String: CGSize] = [
            "Twitter Post": CGSize(width: 1200, height: 675),
            "Twitter Header": CGSize(width: 1500, height: 500),
            "Instagram Post": CGSize(width: 1080, height: 1080),
            "GitHub Social": CGSize(width: 1280, height: 640),
            "Blog Post": CGSize(width: 800, height: 0) // Auto height
        ]
    }

    // MARK: - Storage Constants
    enum Storage {
        static let maxLibraryItems = 1000
        static let defaultLibraryItems = 100
        static let maxRecentItems = 10

        static let screenshotsDirectoryName = "CodeSnap"
        static let themesDirectoryName = "Themes"
        static let presetsDirectoryName = "Presets"

        static let filenameDateFormat = "yyyyMMdd_HHmmss"
        static let filenameTemplate = "CodeSnap_{language}_{date}"
    }

    // MARK: - Hotkey Constants
    enum Hotkeys {
        static let defaultQuickCapture = "⌘⇧C" // Cmd+Shift+C
        static let defaultOpenLibrary = "⌘⇧L" // Cmd+Shift+L
        static let defaultNewFromClipboard = "⌘⇧N" // Cmd+Shift+N
    }

    // MARK: - Watermark Constants
    enum Watermark {
        static let defaultText = "Created with CodeSnap"
        static let defaultOpacity: CGFloat = 0.4
        static let defaultPosition = WatermarkPosition.bottomRight
        static let fontSize: CGFloat = 12
        static let padding: CGFloat = 16
    }

    // MARK: - Theme Constants
    enum Themes {
        static let defaultLightTheme = "github-light"
        static let defaultDarkTheme = "github-dark"

        static let builtInThemes = [
            // Light themes
            "github-light",
            "rose-pine-dawn",
            "solarized-light",
            "nord-light",
            "one-light",

            // Dark themes
            "github-dark",
            "dracula",
            "nord",
            "one-dark",
            "monokai-pro",
            "catppuccin",
            "tokyo-night",
            "synthwave-84",
            "material-dark",
            "gruvbox"
        ]
    }

    // MARK: - Language Detection
    enum Languages {
        static let supported = [
            "javascript", "typescript", "jsx", "tsx",
            "python", "java", "kotlin", "c", "cpp", "csharp",
            "go", "rust", "swift", "ruby", "php",
            "html", "css", "scss", "sass",
            "sql", "bash", "shell", "powershell",
            "yaml", "json", "xml", "markdown",
            "vue", "svelte", "dart", "elixir", "haskell",
            "lua", "perl", "r", "scala", "clojure"
        ]

        static let defaultLanguage = "plaintext"
    }

    // MARK: - Color Palette
    enum Colors {
        // Light Mode
        static let lightBackground = Color(hex: "#FFFFFF")
        static let lightSecondary = Color(hex: "#F6F6F8")
        static let lightTertiary = Color(hex: "#EFEFEF")
        static let lightTextPrimary = Color(hex: "#1A1A1A")
        static let lightTextSecondary = Color(hex: "#6B6B6B")
        static let lightTextTertiary = Color(hex: "#9B9B9B")
        static let lightAccent = Color(hex: "#007AFF")

        // Dark Mode
        static let darkBackground = Color(hex: "#1E1E1E")
        static let darkSecondary = Color(hex: "#2D2D2D")
        static let darkTertiary = Color(hex: "#3A3A3A")
        static let darkTextPrimary = Color(hex: "#FFFFFF")
        static let darkTextSecondary = Color(hex: "#ABABAB")
        static let darkTextTertiary = Color(hex: "#6B6B6B")
        static let darkAccent = Color(hex: "#0A84FF")

        // UI Elements
        static let success = Color(hex: "#34C759")
        static let warning = Color(hex: "#FF9500")
        static let error = Color(hex: "#FF3B30")
        static let code = Color(hex: "#FF6B6B")
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
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
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    func toHex() -> String {
        let components = NSColor(self).cgColor.components
        let r = Float(components?[0] ?? 0)
        let g = Float(components?[1] ?? 0)
        let b = Float(components?[2] ?? 0)

        return String(format: "#%02lX%02lX%02lX",
                     lroundf(r * 255),
                     lroundf(g * 255),
                     lroundf(b * 255))
    }
}
