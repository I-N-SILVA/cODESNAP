//
//  ShadowRenderer.swift
//  CodeSnap
//
//  Add shadow effects to screenshots
//

import Foundation
import AppKit

class ShadowRenderer {
    static let shared = ShadowRenderer()

    private init() {}

    // MARK: - Main Rendering Method

    func applyShadow(_ config: ShadowConfig, to context: CGContext, contentRect: CGRect) {
        guard config.enabled else { return }

        let shadowColor = NSColor(hex: config.color)?.withAlphaComponent(config.opacity) ?? NSColor.black.withAlphaComponent(config.opacity)

        context.saveGState()

        context.setShadow(
            offset: CGSize(width: 0, height: -config.offsetY),
            blur: config.blur,
            color: shadowColor.cgColor
        )

        context.restoreGState()
    }

    // Calculate total size needed including shadow
    func calculateTotalSize(contentSize: CGSize, shadow: ShadowConfig) -> CGSize {
        guard shadow.enabled else { return contentSize }

        let shadowPadding = shadow.blur + abs(shadow.offsetY)
        let extraPadding = shadowPadding * 2 // Add padding on all sides

        return CGSize(
            width: contentSize.width + extraPadding,
            height: contentSize.height + extraPadding
        )
    }

    // Get offset for content within total size (to account for shadow)
    func getContentOffset(shadow: ShadowConfig) -> CGPoint {
        guard shadow.enabled else { return .zero }

        let shadowPadding = shadow.blur + abs(shadow.offsetY)

        return CGPoint(
            x: shadowPadding,
            y: shadowPadding - shadow.offsetY
        )
    }
}
