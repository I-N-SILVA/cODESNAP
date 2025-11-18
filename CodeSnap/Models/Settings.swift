//
//  Settings.swift
//  CodeSnap
//
//  App settings and preferences
//

import Foundation
import SwiftUI

struct AppSettings: Codable {
    // MARK: - General Settings

    var launchAtLogin: Bool = false
    var showMenuBarIcon: Bool = true
    var showInDock: Bool = false
    var autoCheckUpdates: Bool = true
    var enableAnalytics: Bool = true
    var enableCrashReporting: Bool = true

    // MARK: - Hotkey Settings

    var quickCaptureHotkey: String = "⌘⇧C"  // Cmd+Shift+C
    var openLibraryHotkey: String = "⌘⇧L"  // Cmd+Shift+L
    var newFromClipboardHotkey: String = "⌘⇧N"  // Cmd+Shift+N

    // MARK: - Clipboard Monitoring

    var enableClipboardMonitoring: Bool = false
    var autoDetectCode: Bool = true
    var showCodeDetectionNotification: Bool = true

    // MARK: - Default Settings

    var defaultTheme: String = "github-dark"
    var defaultWindowStyle: WindowStyle = .macos
    var defaultBackground: BackgroundStyle = .gradient("#667eea", "#764ba2")
    var defaultFontFamily: String = "JetBrains Mono"
    var defaultFontSize: CGFloat = 16
    var defaultLineHeight: CGFloat = 1.5
    var defaultPadding: CGFloat = 48
    var defaultBorderRadius: CGFloat = 12
    var defaultShadow: ShadowConfig = ShadowConfig()
    var defaultExportSize: CGFloat = 2.0
    var defaultExportFormat: ExportFormat = .png
    var defaultShowLineNumbers: Bool = true
    var defaultEnableLigatures: Bool = true

    // MARK: - Storage Settings

    var saveLocation: String = ""  // Will be initialized in init
    var autoSaveScreenshots: Bool = true
    var keepHistoryCount: Int = 100
    var maxLibrarySize: Int = 1000

    // MARK: - Export Settings

    var jpegQuality: CGFloat = 0.9
    var autoCopyToClipboard: Bool = false
    var autoSaveToFile: Bool = false
    var showExportNotification: Bool = true
    var filenameTemplate: String = "CodeSnap_{language}_{date}"

    // MARK: - Watermark Settings (Free Tier)

    var showWatermark: Bool = true
    var watermarkPosition: WatermarkPosition = .bottomRight
    var watermarkOpacity: CGFloat = 0.4
    var watermarkText: String = "Created with CodeSnap"
    var watermarkSize: WatermarkSize = .medium

    // MARK: - UI Settings

    var appTheme: AppTheme = .auto
    var showLivePreview: Bool = true
    var autoZoomToFit: Bool = true
    var previewGridOpacity: CGFloat = 0.2
    var animationsEnabled: Bool = true

    // MARK: - Pro Settings

    var isProVersion: Bool = false
    var proLicenseKey: String = ""
    var proActivationDate: Date?

    // MARK: - Library Settings

    var libraryViewMode: LibraryViewMode = .grid
    var librarySortBy: LibrarySortOption = .dateCreated
    var librarySortAscending: Bool = false
    var libraryFilterLanguage: String?
    var showFavoritesOnly: Bool = false

    // MARK: - Initialization

    init() {
        // Set default save location
        let picturesURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first
        let codeSnapURL = picturesURL?.appendingPathComponent("CodeSnap")
        self.saveLocation = codeSnapURL?.path ?? ""

        // Create directory if it doesn't exist
        if let url = codeSnapURL {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }

    // MARK: - Methods

    mutating func activateProVersion(licenseKey: String) -> Bool {
        // TODO: Validate license key with server
        // For now, simple validation
        guard !licenseKey.isEmpty else { return false }

        self.isProVersion = true
        self.proLicenseKey = licenseKey
        self.proActivationDate = Date()
        self.showWatermark = false

        return true
    }

    mutating func resetDefaults() {
        self = AppSettings()
    }

    func getSaveURL() -> URL? {
        guard !saveLocation.isEmpty else { return nil }
        return URL(fileURLWithPath: saveLocation)
    }

    mutating func setSaveLocation(_ url: URL) {
        self.saveLocation = url.path

        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }
}

// MARK: - Supporting Enums

enum WatermarkPosition: String, Codable, CaseIterable {
    case topLeft = "topLeft"
    case topRight = "topRight"
    case bottomLeft = "bottomLeft"
    case bottomRight = "bottomRight"

    var displayName: String {
        switch self {
        case .topLeft: return "Top Left"
        case .topRight: return "Top Right"
        case .bottomLeft: return "Bottom Left"
        case .bottomRight: return "Bottom Right"
        }
    }
}

enum WatermarkSize: String, Codable, CaseIterable {
    case small = "small"
    case medium = "medium"
    case large = "large"

    var fontSize: CGFloat {
        switch self {
        case .small: return 10
        case .medium: return 12
        case .large: return 14
        }
    }

    var displayName: String {
        rawValue.capitalized
    }
}

enum AppTheme: String, Codable, CaseIterable {
    case auto = "auto"
    case light = "light"
    case dark = "dark"

    var displayName: String {
        switch self {
        case .auto: return "Auto (System)"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .auto: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum LibraryViewMode: String, Codable {
    case grid = "grid"
    case list = "list"
}

enum LibrarySortOption: String, Codable, CaseIterable {
    case dateCreated = "dateCreated"
    case dateModified = "dateModified"
    case language = "language"
    case name = "name"

    var displayName: String {
        switch self {
        case .dateCreated: return "Date Created"
        case .dateModified: return "Date Modified"
        case .language: return "Language"
        case .name: return "Name"
        }
    }
}

// MARK: - User Defaults Extension

extension UserDefaults {
    private static let settingsKey = "AppSettings"

    func saveSettings(_ settings: AppSettings) {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        set(data, forKey: Self.settingsKey)
    }

    func loadSettings() -> AppSettings {
        guard let data = data(forKey: Self.settingsKey),
              let settings = try? JSONDecoder().decode(AppSettings.self, from: data) else {
            return AppSettings()
        }
        return settings
    }
}
