//
//  ExportService.swift
//  CodeSnap
//
//  Multi-format export service (PNG, JPEG, SVG, PDF)
//

import Foundation
import AppKit

class ExportService {
    static let shared = ExportService()

    private init() {}

    // MARK: - Export Methods

    func export(
        image: NSImage,
        format: ExportFormat,
        quality: CGFloat = 0.9,
        to url: URL? = nil
    ) throws -> URL {
        let exportURL: URL

        if let url = url {
            exportURL = url
        } else {
            // Generate default filename
            let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
            let filename = "CodeSnap_\(timestamp)\(format.fileExtension)"
            let defaultURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
                .appendingPathComponent(filename)
            exportURL = defaultURL
        }

        switch format {
        case .png:
            try exportPNG(image: image, to: exportURL)

        case .jpeg:
            try exportJPEG(image: image, quality: quality, to: exportURL)

        case .svg:
            try exportSVG(image: image, to: exportURL)

        case .pdf:
            try exportPDF(image: image, to: exportURL)
        }

        return exportURL
    }

    // MARK: - Format-Specific Export

    private func exportPNG(image: NSImage, to url: URL) throws {
        guard let tiffData = image.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData),
              let pngData = bitmapImage.representation(using: .png, properties: [:]) else {
            throw ExportError.conversionFailed
        }

        try pngData.write(to: url)
    }

    private func exportJPEG(image: NSImage, quality: CGFloat, to url: URL) throws {
        guard let tiffData = image.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData),
              let jpegData = bitmapImage.representation(using: .jpeg, properties: [.compressionFactor: quality]) else {
            throw ExportError.conversionFailed
        }

        try jpegData.write(to: url)
    }

    private func exportSVG(image: NSImage, to url: URL) throws {
        // SVG export is complex and would require converting the rendered bitmap to vector
        // For MVP, we'll throw not implemented
        // In production, you could use a library or convert via PDF
        throw ExportError.formatNotSupported
    }

    private func exportPDF(image: NSImage, to url: URL) throws {
        // Create PDF from image
        let pdfData = NSMutableData()

        guard let consumer = CGDataConsumer(data: pdfData as CFMutableData) else {
            throw ExportError.conversionFailed
        }

        let mediaBox = CGRect(origin: .zero, size: image.size)
        var mediaBoxVar = mediaBox

        guard let context = CGContext(consumer: consumer, mediaBox: &mediaBoxVar, nil) else {
            throw ExportError.conversionFailed
        }

        context.beginPDFPage(nil)

        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw ExportError.conversionFailed
        }

        context.draw(cgImage, in: mediaBox)
        context.endPDFPage()
        context.closePDF()

        try pdfData.write(to: url)
    }

    // MARK: - Copy to Clipboard

    func copyToClipboard(image: NSImage) {
        NSPasteboard.copy(image)
    }

    // MARK: - Share

    func share(image: NSImage, from view: NSView) {
        let picker = NSSharingServicePicker(items: [image])
        picker.show(relativeTo: .zero, of: view, preferredEdge: .minY)
    }

    // MARK: - Batch Export

    func batchExport(
        screenshots: [Screenshot],
        format: ExportFormat,
        quality: CGFloat = 0.9,
        toDirectory url: URL
    ) async throws -> [URL] {
        var exportedURLs: [URL] = []

        for screenshot in screenshots {
            do {
                let image = try await CodeRenderer.shared.render(screenshot: screenshot)
                let filename = screenshot.filename.replacingOccurrences(of: ".png", with: format.fileExtension)
                let fileURL = url.appendingPathComponent(filename)

                let exportedURL = try export(image: image, format: format, quality: quality, to: fileURL)
                exportedURLs.append(exportedURL)
            } catch {
                print("Failed to export screenshot \(screenshot.id): \(error)")
                // Continue with other screenshots
            }
        }

        return exportedURLs
    }

    // MARK: - Export with Settings

    func exportWithSettings(screenshot: Screenshot) async throws -> URL {
        let settings = AppSettingsManager.shared.settings

        // Render screenshot
        let image = try await CodeRenderer.shared.render(screenshot: screenshot)

        // Get export location
        let exportURL: URL
        if settings.autoSaveToFile, let saveURL = settings.getSaveURL() {
            exportURL = saveURL.appendingPathComponent(screenshot.filename)
        } else {
            // Prompt user for location
            let panel = NSSavePanel()
            panel.nameFieldStringValue = screenshot.filename
            panel.allowedContentTypes = [.init(filenameExtension: settings.defaultExportFormat.fileExtension)!]

            guard panel.runModal() == .OK, let url = panel.url else {
                throw ExportError.userCancelled
            }

            exportURL = url
        }

        // Export
        let finalURL = try export(
            image: image,
            format: settings.defaultExportFormat,
            quality: settings.jpegQuality,
            to: exportURL
        )

        // Auto-copy if enabled
        if settings.autoCopyToClipboard {
            copyToClipboard(image: image)
        }

        // Show notification if enabled
        if settings.showExportNotification {
            showNotification(title: "Exported!", message: "Screenshot saved to \(finalURL.lastPathComponent)")
        }

        return finalURL
    }

    // MARK: - Size Presets

    func exportWithSize(
        image: NSImage,
        preset: SizePreset,
        format: ExportFormat,
        to url: URL
    ) throws -> URL {
        let resizedImage: NSImage

        switch preset {
        case .actual:
            resizedImage = image

        case .retina:
            resizedImage = image // Already at 2x

        case .ultraHD:
            resizedImage = resizeImage(image, scale: 1.5) // 3x

        case .print:
            resizedImage = resizeImage(image, scale: 2.0) // 4x

        case .custom(let size):
            resizedImage = resizeImage(image, toSize: size)

        case .socialMedia(let platform):
            resizedImage = resizeForSocialMedia(image, platform: platform)
        }

        return try export(image: resizedImage, format: format, to: url)
    }

    // MARK: - Helper Methods

    private func resizeImage(_ image: NSImage, scale: CGFloat) -> NSImage {
        let newSize = CGSize(
            width: image.size.width * scale,
            height: image.size.height * scale
        )
        return resizeImage(image, toSize: newSize)
    }

    private func resizeImage(_ image: NSImage, toSize size: CGSize) -> NSImage {
        let resized = NSImage(size: size)
        resized.lockFocus()
        image.draw(in: CGRect(origin: .zero, size: size))
        resized.unlockFocus()
        return resized
    }

    private func resizeForSocialMedia(_ image: NSImage, platform: SocialMediaPlatform) -> NSImage {
        let targetSize: CGSize

        switch platform {
        case .twitterPost:
            targetSize = CGSize(width: 1200, height: 675)
        case .twitterHeader:
            targetSize = CGSize(width: 1500, height: 500)
        case .instagram:
            targetSize = CGSize(width: 1080, height: 1080)
        case .github:
            targetSize = CGSize(width: 1280, height: 640)
        case .blog:
            targetSize = CGSize(width: 800, height: 0) // Auto height
        }

        if targetSize.height == 0 {
            // Calculate height maintaining aspect ratio
            let aspectRatio = image.size.height / image.size.width
            let calculatedSize = CGSize(width: targetSize.width, height: targetSize.width * aspectRatio)
            return resizeImage(image, toSize: calculatedSize)
        }

        return resizeImage(image, toSize: targetSize)
    }

    private func showNotification(title: String, message: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = message
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
}

// MARK: - Export Error

enum ExportError: Error, LocalizedError {
    case conversionFailed
    case formatNotSupported
    case userCancelled
    case writeFailed

    var errorDescription: String? {
        switch self {
        case .conversionFailed:
            return "Failed to convert image to the requested format"
        case .formatNotSupported:
            return "This export format is not yet supported"
        case .userCancelled:
            return "Export was cancelled by user"
        case .writeFailed:
            return "Failed to write file to disk"
        }
    }
}

// MARK: - Size Presets

enum SizePreset {
    case actual           // 1x
    case retina          // 2x
    case ultraHD         // 3x
    case print           // 4x
    case custom(CGSize)
    case socialMedia(SocialMediaPlatform)
}

enum SocialMediaPlatform {
    case twitterPost
    case twitterHeader
    case instagram
    case github
    case blog
}
