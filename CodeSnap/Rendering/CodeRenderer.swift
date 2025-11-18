//
//  CodeRenderer.swift
//  CodeSnap
//
//  Main code rendering engine (code → beautiful image)
//

import Foundation
import AppKit

class CodeRenderer {
    static let shared = CodeRenderer()

    private let syntaxHighlighter = SyntaxHighlighter.shared
    private let backgroundRenderer = BackgroundRenderer.shared
    private let windowDecorator = WindowDecorator.shared
    private let shadowRenderer = ShadowRenderer.shared
    private let watermarkRenderer = WatermarkRenderer.shared

    private init() {}

    // MARK: - Main Rendering Method

    func render(screenshot: Screenshot) async throws -> NSImage {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let image = try self.renderSync(screenshot: screenshot)
                    continuation.resume(returning: image)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func renderSync(screenshot: Screenshot) throws -> NSImage {
        // Get theme
        guard let theme = ThemeManager.shared.getTheme(named: screenshot.theme) else {
            throw RenderError.themeNotFound
        }

        // 1. Create attributed string with syntax highlighting
        let attributedCode = syntaxHighlighter.highlight(
            code: screenshot.code,
            language: screenshot.language,
            theme: theme,
            fontSize: screenshot.fontSize,
            fontFamily: screenshot.fontFamily,
            lineHeight: screenshot.lineHeight
        )

        // 2. Calculate text size
        let textSize = calculateTextSize(attributedCode, maxWidth: 1200)

        // 3. Calculate content size (text + padding)
        let chromeHeight = windowDecorator.getChromeHeight(for: screenshot.windowStyle)
        let contentSize = CGSize(
            width: textSize.width + screenshot.padding * 2,
            height: textSize.height + screenshot.padding * 2 + chromeHeight
        )

        // 4. Calculate total size (including shadow)
        let totalSize = shadowRenderer.calculateTotalSize(contentSize: contentSize, shadow: screenshot.shadow)

        // 5. Create image context
        let scale = screenshot.exportSize
        guard let context = CGContext(
            data: nil,
            width: Int(totalSize.width * scale),
            height: Int(totalSize.height * scale),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw RenderError.contextCreationFailed
        }

        // Scale context
        context.scaleBy(x: scale, y: scale)

        // Flip coordinate system (CoreGraphics is bottom-left, we want top-left)
        context.translateBy(x: 0, y: totalSize.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // 6. Get content offset (for shadow)
        let contentOffset = shadowRenderer.getContentOffset(shadow: screenshot.shadow)
        let contentRect = CGRect(
            x: contentOffset.x,
            y: contentOffset.y,
            width: contentSize.width,
            height: contentSize.height
        )

        // 7. Apply shadow if enabled
        if screenshot.shadow.enabled {
            shadowRenderer.applyShadow(screenshot.shadow, to: context, contentRect: contentRect)
        }

        // 8. Render background
        backgroundRenderer.render(
            background: screenshot.backgroundColor,
            in: context,
            size: contentSize,
            cornerRadius: screenshot.borderRadius
        )

        // Draw at content offset
        context.saveGState()
        context.translateBy(x: contentOffset.x, y: contentOffset.y)

        // 9. Render window chrome
        if screenshot.windowStyle != .none {
            windowDecorator.render(
                style: screenshot.windowStyle,
                in: context,
                rect: CGRect(origin: .zero, size: contentSize),
                cornerRadius: screenshot.borderRadius,
                isDarkTheme: theme.isDark
            )
        }

        // 10. Render code text
        let textRect = CGRect(
            x: screenshot.padding,
            y: screenshot.padding,
            width: textSize.width,
            height: textSize.height
        )

        // Flip back for text rendering
        context.saveGState()
        context.translateBy(x: 0, y: contentSize.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // Adjust text position for chrome
        let adjustedTextRect = CGRect(
            x: textRect.minX,
            y: textRect.minY + chromeHeight,
            width: textRect.width,
            height: textRect.height
        )

        attributedCode.draw(in: adjustedTextRect)

        context.restoreGState()

        // 11. Render watermark
        if AppSettingsManager.shared.settings.showWatermark && !AppSettingsManager.shared.settings.isProVersion {
            // Flip back for watermark
            context.saveGState()
            context.translateBy(x: 0, y: contentSize.height)
            context.scaleBy(x: 1.0, y: -1.0)

            watermarkRenderer.render(
                in: context,
                rect: CGRect(origin: .zero, size: contentSize),
                settings: AppSettingsManager.shared.settings
            )

            context.restoreGState()
        }

        context.restoreGState()

        // 12. Create final NSImage
        guard let cgImage = context.makeImage() else {
            throw RenderError.imageCreationFailed
        }

        let finalImage = NSImage(cgImage: cgImage, size: totalSize)

        return finalImage
    }

    // MARK: - Helper Methods

    private func calculateTextSize(_ attributedString: NSAttributedString, maxWidth: CGFloat = 1200) -> CGSize {
        let textContainer = NSTextContainer(size: CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = 0

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        let textStorage = NSTextStorage(attributedString: attributedString)
        textStorage.addLayoutManager(layoutManager)

        layoutManager.glyphRange(for: textContainer)

        let usedRect = layoutManager.usedRect(for: textContainer)

        return CGSize(
            width: ceil(usedRect.width),
            height: ceil(usedRect.height)
        )
    }

    // MARK: - Thumbnail Generation

    func generateThumbnail(screenshot: Screenshot, size: CGSize = CGSize(width: 180, height: 140)) async throws -> NSImage {
        // Create a smaller version for thumbnails
        var thumbnailScreenshot = screenshot
        thumbnailScreenshot.fontSize = 10
        thumbnailScreenshot.padding = 16
        thumbnailScreenshot.exportSize = 1.0
        thumbnailScreenshot.shadow.enabled = false

        let fullImage = try await render(screenshot: thumbnailScreenshot)

        // Resize to thumbnail size
        let thumbnail = NSImage(size: size)
        thumbnail.lockFocus()

        let aspectRatio = fullImage.size.width / fullImage.size.height
        var drawRect = CGRect(origin: .zero, size: size)

        if aspectRatio > size.width / size.height {
            // Image is wider
            let newHeight = size.width / aspectRatio
            drawRect = CGRect(
                x: 0,
                y: (size.height - newHeight) / 2,
                width: size.width,
                height: newHeight
            )
        } else {
            // Image is taller
            let newWidth = size.height * aspectRatio
            drawRect = CGRect(
                x: (size.width - newWidth) / 2,
                y: 0,
                width: newWidth,
                height: size.height
            )
        }

        fullImage.draw(in: drawRect)
        thumbnail.unlockFocus()

        return thumbnail
    }

    // MARK: - Quick Render (for preview)

    func quickRender(code: String, language: String, theme: String = "github-dark") async throws -> NSImage {
        let screenshot = Screenshot(
            code: code,
            language: language,
            theme: theme,
            windowStyle: .macos,
            backgroundColor: .gradient("#667eea", "#764ba2"),
            fontSize: 14,
            fontFamily: "Menlo",
            padding: 40,
            shadow: .medium,
            exportSize: 2.0
        )

        return try await render(screenshot: screenshot)
    }
}

// MARK: - Render Error

enum RenderError: Error, LocalizedError {
    case themeNotFound
    case contextCreationFailed
    case imageCreationFailed
    case invalidCode
    case renderingFailed

    var errorDescription: String? {
        switch self {
        case .themeNotFound:
            return "The selected theme could not be found"
        case .contextCreationFailed:
            return "Failed to create rendering context"
        case .imageCreationFailed:
            return "Failed to create final image"
        case .invalidCode:
            return "The code provided is invalid"
        case .renderingFailed:
            return "Rendering failed due to an unknown error"
        }
    }
}
