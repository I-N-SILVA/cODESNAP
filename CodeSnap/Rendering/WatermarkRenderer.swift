//
//  WatermarkRenderer.swift
//  CodeSnap
//
//  Add watermark for free tier
//

import Foundation
import AppKit

class WatermarkRenderer {
    static let shared = WatermarkRenderer()

    private init() {}

    // MARK: - Main Rendering Method

    func render(in context: CGContext, rect: CGRect, settings: AppSettings) {
        guard settings.showWatermark else { return }

        let text = settings.watermarkText
        let position = settings.watermarkPosition
        let opacity = settings.watermarkOpacity
        let fontSize = settings.watermarkSize.fontSize

        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: fontSize, weight: .medium),
            .foregroundColor: NSColor.white.withAlphaComponent(opacity)
        ]

        let textSize = text.size(withAttributes: attributes)
        let padding: CGFloat = Constants.Watermark.padding

        let point: CGPoint

        switch position {
        case .topLeft:
            point = CGPoint(x: padding, y: rect.maxY - textSize.height - padding)

        case .topRight:
            point = CGPoint(x: rect.maxX - textSize.width - padding, y: rect.maxY - textSize.height - padding)

        case .bottomLeft:
            point = CGPoint(x: padding, y: padding)

        case .bottomRight:
            point = CGPoint(x: rect.maxX - textSize.width - padding, y: padding)
        }

        // Add subtle shadow to watermark for better visibility
        context.saveGState()
        context.setShadow(
            offset: CGSize(width: 0, height: -1),
            blur: 2,
            color: NSColor.black.withAlphaComponent(0.3).cgColor
        )

        text.draw(at: point, withAttributes: attributes)

        context.restoreGState()
    }

    // Calculate if watermark will be visible
    func willBeVisible(settings: AppSettings) -> Bool {
        return settings.showWatermark && settings.watermarkOpacity > 0
    }

    // Get watermark text size
    func getSize(settings: AppSettings) -> CGSize {
        let text = settings.watermarkText
        let fontSize = settings.watermarkSize.fontSize

        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: fontSize, weight: .medium)
        ]

        return text.size(withAttributes: attributes)
    }
}
