//
//  BackgroundRenderer.swift
//  CodeSnap
//
//  Render backgrounds (solid, gradient, transparent, image)
//

import Foundation
import AppKit

class BackgroundRenderer {
    static let shared = BackgroundRenderer()

    private init() {}

    // MARK: - Main Rendering Method

    func render(background: BackgroundStyle, in context: CGContext, size: CGSize, cornerRadius: CGFloat = 0) {
        let rect = CGRect(origin: .zero, size: size)

        switch background {
        case .transparent:
            // Nothing to draw for transparent background
            break

        case .solid(let hexColor):
            renderSolid(hex: hexColor, in: context, rect: rect, cornerRadius: cornerRadius)

        case .gradient(let startHex, let endHex):
            renderGradient(startHex: startHex, endHex: endHex, in: context, rect: rect, cornerRadius: cornerRadius)

        case .image(let url):
            renderImage(url: url, in: context, rect: rect, cornerRadius: cornerRadius)
        }
    }

    // MARK: - Rendering Methods

    private func renderSolid(hex: String, in context: CGContext, rect: CGRect, cornerRadius: CGFloat) {
        guard let color = NSColor(hex: hex) else { return }

        context.saveGState()

        if cornerRadius > 0 {
            let path = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
            context.addPath(path.cgPath)
            context.clip()
        }

        context.setFillColor(color.cgColor)
        context.fill(rect)

        context.restoreGState()
    }

    private func renderGradient(startHex: String, endHex: String, in context: CGContext, rect: CGRect, cornerRadius: CGFloat) {
        guard let startColor = NSColor(hex: startHex),
              let endColor = NSColor(hex: endHex),
              let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [startColor.cgColor, endColor.cgColor] as CFArray,
                locations: [0.0, 1.0]
              ) else { return }

        context.saveGState()

        if cornerRadius > 0 {
            let path = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
            context.addPath(path.cgPath)
            context.clip()
        }

        // Linear gradient from top-left to bottom-right
        let startPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endPoint = CGPoint(x: rect.maxX, y: rect.minY)

        context.drawLinearGradient(
            gradient,
            start: startPoint,
            end: endPoint,
            options: []
        )

        context.restoreGState()
    }

    private func renderImage(url: URL, in context: CGContext, rect: CGRect, cornerRadius: CGFloat) {
        guard let image = NSImage(contentsOf: url),
              let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }

        context.saveGState()

        if cornerRadius > 0 {
            let path = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
            context.addPath(path.cgPath)
            context.clip()
        }

        context.draw(cgImage, in: rect)

        context.restoreGState()
    }

    // MARK: - Utility Methods

    func getColor(from background: BackgroundStyle) -> NSColor? {
        switch background {
        case .transparent:
            return .clear
        case .solid(let hex):
            return NSColor(hex: hex)
        case .gradient(let startHex, _):
            return NSColor(hex: startHex) // Return start color
        case .image:
            return nil
        }
    }

    func isTransparent(_ background: BackgroundStyle) -> Bool {
        if case .transparent = background {
            return true
        }
        return false
    }
}

// MARK: - NSBezierPath CGPath Extension

extension NSBezierPath {
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)

        for i in 0..<self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                break
            }
        }

        return path
    }
}
