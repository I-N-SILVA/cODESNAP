//
//  Screenshot.swift
//  CodeSnap
//
//  Model for code screenshots
//

import Foundation
import AppKit

struct Screenshot: Codable, Identifiable, Hashable {
    let id: UUID
    var code: String
    var language: String
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
    var createdAt: Date
    var modifiedAt: Date
    var isFavorite: Bool
    var tags: [String]

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        code: String,
        language: String,
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
        createdAt: Date = Date(),
        modifiedAt: Date = Date(),
        isFavorite: Bool = false,
        tags: [String] = []
    ) {
        self.id = id
        self.code = code
        self.language = language
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
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.isFavorite = isFavorite
        self.tags = tags
    }

    // MARK: - Computed Properties

    var filename: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Storage.filenameDateFormat
        let dateString = formatter.string(from: createdAt)

        return "CodeSnap_\(language)_\(dateString).png"
    }

    var lineCount: Int {
        code.components(separatedBy: .newlines).count
    }

    var characterCount: Int {
        code.count
    }

    var firstTwoLines: String {
        let lines = code.components(separatedBy: .newlines)
        return lines.prefix(2).joined(separator: "\n")
    }

    // MARK: - Methods

    mutating func toggleFavorite() {
        isFavorite.toggle()
        modifiedAt = Date()
    }

    mutating func addTag(_ tag: String) {
        if !tags.contains(tag) {
            tags.append(tag)
            modifiedAt = Date()
        }
    }

    mutating func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
        modifiedAt = Date()
    }

    mutating func updateCode(_ newCode: String) {
        code = newCode
        modifiedAt = Date()
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Screenshot, rhs: Screenshot) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Window Style

enum WindowStyle: String, Codable, CaseIterable, Identifiable {
    case none = "none"
    case macos = "macos"
    case browser = "browser"
    case vscode = "vscode"
    case terminal = "terminal"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .none: return "None"
        case .macos: return "macOS"
        case .browser: return "Browser"
        case .vscode: return "VS Code"
        case .terminal: return "Terminal"
        }
    }

    var icon: String {
        switch self {
        case .none: return "rectangle"
        case .macos: return "macwindow"
        case .browser: return "globe"
        case .vscode: return "chevron.left.forwardslash.chevron.right"
        case .terminal: return "terminal"
        }
    }
}

// MARK: - Background Style

enum BackgroundStyle: Codable, Hashable {
    case transparent
    case solid(String) // Hex color
    case gradient(String, String) // Start and end colors (hex)
    case image(URL)

    // Default gradients
    static let presetGradients: [(String, BackgroundStyle)] = [
        ("Sunset", .gradient("#ff6b6b", "#feca57")),
        ("Ocean", .gradient("#667eea", "#764ba2")),
        ("Forest", .gradient("#11998e", "#38ef7d")),
        ("Purple Haze", .gradient("#6a3093", "#a044ff")),
        ("Fire", .gradient("#f12711", "#f5af19")),
        ("Blue Sky", .gradient("#4facfe", "#00f2fe")),
        ("Pink Dream", .gradient("#fa709a", "#fee140")),
        ("Dark Ocean", .gradient("#2e3192", "#1bffff"))
    ]

    var displayName: String {
        switch self {
        case .transparent:
            return "Transparent"
        case .solid(let color):
            return "Solid (\(color))"
        case .gradient(let start, let end):
            return "Gradient (\(start) → \(end))"
        case .image(let url):
            return "Image (\(url.lastPathComponent))"
        }
    }
}

// MARK: - Shadow Configuration

struct ShadowConfig: Codable, Hashable {
    var enabled: Bool
    var size: CGFloat
    var blur: CGFloat
    var color: String // Hex color with alpha
    var offsetY: CGFloat
    var opacity: CGFloat

    init(
        enabled: Bool = true,
        size: CGFloat = 40,
        blur: CGFloat = 60,
        color: String = "#000000",
        offsetY: CGFloat = 8,
        opacity: CGFloat = 0.3
    ) {
        self.enabled = enabled
        self.size = size
        self.blur = blur
        self.color = color
        self.offsetY = offsetY
        self.opacity = opacity
    }

    static let none = ShadowConfig(enabled: false, size: 0, blur: 0, opacity: 0)
    static let small = ShadowConfig(size: 20, blur: 30, offsetY: 4, opacity: 0.2)
    static let medium = ShadowConfig(size: 40, blur: 60, offsetY: 8, opacity: 0.3)
    static let large = ShadowConfig(size: 60, blur: 90, offsetY: 12, opacity: 0.4)
}

// MARK: - Export Format

enum ExportFormat: String, Codable, CaseIterable, Identifiable {
    case png = "png"
    case jpeg = "jpeg"
    case svg = "svg"
    case pdf = "pdf"

    var id: String { rawValue }

    var displayName: String {
        rawValue.uppercased()
    }

    var fileExtension: String {
        switch self {
        case .png: return ".png"
        case .jpeg: return ".jpg"
        case .svg: return ".svg"
        case .pdf: return ".pdf"
        }
    }

    var supportsTransparency: Bool {
        switch self {
        case .png, .svg, .pdf: return true
        case .jpeg: return false
        }
    }
}
