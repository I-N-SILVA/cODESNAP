//
//  StorageManager.swift
//  CodeSnap
//
//  Manage file storage for screenshots and data
//

import Foundation
import AppKit

class StorageManager {
    static let shared = StorageManager()

    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        setupDirectories()
    }

    // MARK: - Directories

    var screenshotsDirectory: URL {
        let settings = AppSettingsManager.shared.settings
        if let url = settings.getSaveURL() {
            return url
        }

        // Fallback to Pictures/CodeSnap
        let pictures = fileManager.urls(for: .picturesDirectory, in: .userDomainMask).first!
        return pictures.appendingPathComponent("CodeSnap")
    }

    var themesDirectory: URL {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return appSupport.appendingPathComponent("CodeSnap/Themes")
    }

    var presetsDirectory: URL {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return appSupport.appendingPathComponent("CodeSnap/Presets")
    }

    var libraryDirectory: URL {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return appSupport.appendingPathComponent("CodeSnap/Library")
    }

    private func setupDirectories() {
        let directories = [
            screenshotsDirectory,
            themesDirectory,
            presetsDirectory,
            libraryDirectory
        ]

        for directory in directories {
            try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
    }

    // MARK: - Screenshot Storage

    func saveScreenshot(_ screenshot: Screenshot, image: NSImage) throws -> URL {
        // Save image file
        let imageURL = screenshotsDirectory.appendingPathComponent(screenshot.filename)
        try saveImage(image, to: imageURL)

        // Save metadata
        try saveScreenshotMetadata(screenshot)

        return imageURL
    }

    func saveImage(_ image: NSImage, to url: URL, format: ExportFormat = .png, quality: CGFloat = 0.9) throws {
        guard let tiffData = image.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData) else {
            throw StorageError.imageConversionFailed
        }

        let imageData: Data?

        switch format {
        case .png:
            imageData = bitmapImage.representation(using: .png, properties: [:])
        case .jpeg:
            imageData = bitmapImage.representation(using: .jpeg, properties: [.compressionFactor: quality])
        case .svg:
            // SVG export requires special handling (not implemented yet)
            throw StorageError.formatNotSupported
        case .pdf:
            // PDF export requires special handling (not implemented yet)
            throw StorageError.formatNotSupported
        }

        guard let data = imageData else {
            throw StorageError.imageConversionFailed
        }

        try data.write(to: url)
    }

    private func saveScreenshotMetadata(_ screenshot: Screenshot) throws {
        let metadataURL = libraryDirectory
            .appendingPathComponent(screenshot.id.uuidString)
            .appendingPathExtension("json")

        let data = try encoder.encode(screenshot)
        try data.write(to: metadataURL)
    }

    func loadScreenshots(limit: Int = 100) throws -> [Screenshot] {
        let metadataFiles = try fileManager.contentsOfDirectory(
            at: libraryDirectory,
            includingPropertiesForKeys: [.creationDateKey],
            options: [.skipsHiddenFiles]
        )

        let screenshots = metadataFiles
            .filter { $0.pathExtension == "json" }
            .prefix(limit)
            .compactMap { url -> Screenshot? in
                guard let data = try? Data(contentsOf: url),
                      let screenshot = try? decoder.decode(Screenshot.self, from: data) else {
                    return nil
                }
                return screenshot
            }

        return screenshots.sorted { $0.createdAt > $1.createdAt }
    }

    func deleteScreenshot(_ screenshot: Screenshot) throws {
        // Delete image file
        let imageURL = screenshotsDirectory.appendingPathComponent(screenshot.filename)
        try? fileManager.removeItem(at: imageURL)

        // Delete metadata
        let metadataURL = libraryDirectory
            .appendingPathComponent(screenshot.id.uuidString)
            .appendingPathExtension("json")
        try? fileManager.removeItem(at: metadataURL)
    }

    func deleteOldScreenshots(keepCount: Int) throws {
        let screenshots = try loadScreenshots(limit: 10000)
        let toDelete = screenshots.dropFirst(keepCount)

        for screenshot in toDelete {
            try? deleteScreenshot(screenshot)
        }
    }

    // MARK: - Theme Storage

    func saveTheme(_ theme: Theme) throws {
        let url = themesDirectory
            .appendingPathComponent(theme.name)
            .appendingPathExtension("json")

        let data = try encoder.encode(theme)
        try data.write(to: url)
    }

    func loadThemes() throws -> [Theme] {
        let themeFiles = try fileManager.contentsOfDirectory(
            at: themesDirectory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )

        let themes = themeFiles
            .filter { $0.pathExtension == "json" }
            .compactMap { url -> Theme? in
                guard let data = try? Data(contentsOf: url),
                      let theme = try? decoder.decode(Theme.self, from: data) else {
                    return nil
                }
                return theme
            }

        return themes
    }

    func deleteTheme(_ theme: Theme) throws {
        guard !theme.isBuiltIn else {
            throw StorageError.cannotDeleteBuiltIn
        }

        let url = themesDirectory
            .appendingPathComponent(theme.name)
            .appendingPathExtension("json")

        try fileManager.removeItem(at: url)
    }

    // MARK: - Preset Storage

    func savePreset(_ preset: Preset) throws {
        let url = presetsDirectory
            .appendingPathComponent(preset.id.uuidString)
            .appendingPathExtension("json")

        let data = try encoder.encode(preset)
        try data.write(to: url)
    }

    func loadPresets() throws -> [Preset] {
        let presetFiles = try fileManager.contentsOfDirectory(
            at: presetsDirectory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )

        let presets = presetFiles
            .filter { $0.pathExtension == "json" }
            .compactMap { url -> Preset? in
                guard let data = try? Data(contentsOf: url),
                      let preset = try? decoder.decode(Preset.self, from: data) else {
                    return nil
                }
                return preset
            }

        return presets
    }

    func deletePreset(_ preset: Preset) throws {
        guard !preset.isBuiltIn else {
            throw StorageError.cannotDeleteBuiltIn
        }

        let url = presetsDirectory
            .appendingPathComponent(preset.id.uuidString)
            .appendingPathExtension("json")

        try fileManager.removeItem(at: url)
    }

    // MARK: - Export

    func exportScreenshots(_ screenshots: [Screenshot], to url: URL) throws {
        // Create ZIP file with all screenshots
        // TODO: Implement ZIP creation
        throw StorageError.notImplemented
    }

    // MARK: - Cache Management

    func clearCache() throws {
        let cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            .appendingPathComponent("CodeSnap")

        if fileManager.fileExists(atPath: cacheURL.path) {
            try fileManager.removeItem(at: cacheURL)
        }

        try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true)
    }

    func getCacheSize() -> Int64 {
        let cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            .appendingPathComponent("CodeSnap")

        guard let enumerator = fileManager.enumerator(at: cacheURL, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }

        var totalSize: Int64 = 0
        for case let fileURL as URL in enumerator {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: [.fileSizeKey]),
                  let fileSize = resourceValues.fileSize else {
                continue
            }
            totalSize += Int64(fileSize)
        }

        return totalSize
    }
}

// MARK: - Storage Error

enum StorageError: Error {
    case imageConversionFailed
    case formatNotSupported
    case cannotDeleteBuiltIn
    case notImplemented
    case fileNotFound
    case permissionDenied

    var localizedDescription: String {
        switch self {
        case .imageConversionFailed:
            return "Failed to convert image to the requested format"
        case .formatNotSupported:
            return "This export format is not yet supported"
        case .cannotDeleteBuiltIn:
            return "Cannot delete built-in themes or presets"
        case .notImplemented:
            return "This feature is not yet implemented"
        case .fileNotFound:
            return "The requested file was not found"
        case .permissionDenied:
            return "Permission denied to access the file"
        }
    }
}
