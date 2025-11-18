//
//  WindowDecorator.swift
//  CodeSnap
//
//  Add window chrome (macOS, browser, VS Code, terminal)
//

import Foundation
import AppKit

class WindowDecorator {
    static let shared = WindowDecorator()

    private init() {}

    // MARK: - Window Chrome Heights

    static let macOSChromeHeight: CGFloat = 28
    static let browserChromeHeight: CGFloat = 40
    static let vsCodeChromeHeight: CGFloat = 35
    static let terminalChromeHeight: CGFloat = 30

    // MARK: - Main Rendering Method

    func render(style: WindowStyle, in context: CGContext, rect: CGRect, cornerRadius: CGFloat, isDarkTheme: Bool) {
        switch style {
        case .none:
            break // No chrome to render

        case .macos:
            renderMacOSChrome(in: context, rect: rect, cornerRadius: cornerRadius, isDarkTheme: isDarkTheme)

        case .browser:
            renderBrowserChrome(in: context, rect: rect, cornerRadius: cornerRadius, isDarkTheme: isDarkTheme)

        case .vscode:
            renderVSCodeChrome(in: context, rect: rect, cornerRadius: cornerRadius, isDarkTheme: isDarkTheme)

        case .terminal:
            renderTerminalChrome(in: context, rect: rect, cornerRadius: cornerRadius, isDarkTheme: isDarkTheme)
        }
    }

    func getChromeHeight(for style: WindowStyle) -> CGFloat {
        switch style {
        case .none: return 0
        case .macos: return Self.macOSChromeHeight
        case .browser: return Self.browserChromeHeight
        case .vscode: return Self.vsCodeChromeHeight
        case .terminal: return Self.terminalChromeHeight
        }
    }

    // MARK: - macOS Window Chrome

    private func renderMacOSChrome(in context: CGContext, rect: CGRect, cornerRadius: CGFloat, isDarkTheme: Bool) {
        let chromeHeight = Self.macOSChromeHeight
        let chromeRect = CGRect(x: rect.minX, y: rect.maxY - chromeHeight, width: rect.width, height: chromeHeight)

        // Background
        let backgroundColor = isDarkTheme ? NSColor(white: 0.2, alpha: 1.0) : NSColor(white: 0.95, alpha: 1.0)
        context.setFillColor(backgroundColor.cgColor)

        // Only round top corners
        let path = CGMutablePath()
        path.move(to: CGPoint(x: chromeRect.minX, y: chromeRect.minY))
        path.addLine(to: CGPoint(x: chromeRect.minX, y: chromeRect.maxY - cornerRadius))
        path.addArc(
            center: CGPoint(x: chromeRect.minX + cornerRadius, y: chromeRect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .pi,
            endAngle: .pi / 2,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: chromeRect.maxX - cornerRadius, y: chromeRect.maxY))
        path.addArc(
            center: CGPoint(x: chromeRect.maxX - cornerRadius, y: chromeRect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .pi / 2,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: chromeRect.maxX, y: chromeRect.minY))
        path.closeSubpath()

        context.addPath(path)
        context.fillPath()

        // Traffic lights
        let buttonY = chromeRect.midY
        let buttonRadius: CGFloat = 6
        let buttonSpacing: CGFloat = 8
        let leftMargin: CGFloat = 12

        // Close button (red)
        drawCircle(in: context, center: CGPoint(x: leftMargin + buttonRadius, y: buttonY), radius: buttonRadius, color: NSColor(hex: "#FF5F57")!)

        // Minimize button (yellow)
        drawCircle(in: context, center: CGPoint(x: leftMargin + buttonRadius + buttonSpacing + buttonRadius * 2, y: buttonY), radius: buttonRadius, color: NSColor(hex: "#FFBD2E")!)

        // Maximize button (green)
        drawCircle(in: context, center: CGPoint(x: leftMargin + buttonRadius + (buttonSpacing + buttonRadius * 2) * 2, y: buttonY), radius: buttonRadius, color: NSColor(hex: "#28CA42")!)
    }

    // MARK: - Browser Window Chrome

    private func renderBrowserChrome(in context: CGContext, rect: CGRect, cornerRadius: CGFloat, isDarkTheme: Bool) {
        let chromeHeight = Self.browserChromeHeight
        let chromeRect = CGRect(x: rect.minX, y: rect.maxY - chromeHeight, width: rect.width, height: chromeHeight)

        // Background
        let backgroundColor = isDarkTheme ? NSColor(white: 0.15, alpha: 1.0) : NSColor(white: 0.98, alpha: 1.0)
        context.setFillColor(backgroundColor.cgColor)

        // Rounded top
        let path = CGMutablePath()
        path.move(to: CGPoint(x: chromeRect.minX, y: chromeRect.minY))
        path.addLine(to: CGPoint(x: chromeRect.minX, y: chromeRect.maxY - cornerRadius))
        path.addArc(
            center: CGPoint(x: chromeRect.minX + cornerRadius, y: chromeRect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .pi,
            endAngle: .pi / 2,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: chromeRect.maxX - cornerRadius, y: chromeRect.maxY))
        path.addArc(
            center: CGPoint(x: chromeRect.maxX - cornerRadius, y: chromeRect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .pi / 2,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: chromeRect.maxX, y: chromeRect.minY))
        path.closeSubpath()

        context.addPath(path)
        context.fillPath()

        // Tabs area
        let tabsRect = CGRect(x: chromeRect.minX + 8, y: chromeRect.maxY - 28, width: 120, height: 24)
        let tabColor = isDarkTheme ? NSColor(white: 0.25, alpha: 1.0) : NSColor.white
        context.setFillColor(tabColor.cgColor)

        let tabPath = NSBezierPath(roundedRect: tabsRect, xRadius: 6, yRadius: 6)
        context.addPath(tabPath.cgPath)
        context.fillPath()

        // Address bar
        let addressBarRect = CGRect(
            x: chromeRect.minX + 140,
            y: chromeRect.minY + 8,
            width: chromeRect.width - 280,
            height: chromeHeight - 16
        )
        let addressBarColor = isDarkTheme ? NSColor(white: 0.2, alpha: 1.0) : NSColor(white: 0.95, alpha: 1.0)
        context.setFillColor(addressBarColor.cgColor)

        let addressPath = NSBezierPath(roundedRect: addressBarRect, xRadius: 12, yRadius: 12)
        context.addPath(addressPath.cgPath)
        context.fillPath()
    }

    // MARK: - VS Code Window Chrome

    private func renderVSCodeChrome(in context: CGContext, rect: CGRect, cornerRadius: CGFloat, isDarkTheme: Bool) {
        let chromeHeight = Self.vsCodeChromeHeight
        let chromeRect = CGRect(x: rect.minX, y: rect.maxY - chromeHeight, width: rect.width, height: chromeHeight)

        // Background (VS Code title bar color)
        let backgroundColor = isDarkTheme ? NSColor(hex: "#323233")! : NSColor(hex: "#ECECEC")!
        context.setFillColor(backgroundColor.cgColor)

        // Rounded top
        let path = CGMutablePath()
        path.move(to: CGPoint(x: chromeRect.minX, y: chromeRect.minY))
        path.addLine(to: CGPoint(x: chromeRect.minX, y: chromeRect.maxY - cornerRadius))
        path.addArc(
            center: CGPoint(x: chromeRect.minX + cornerRadius, y: chromeRect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .pi,
            endAngle: .pi / 2,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: chromeRect.maxX - cornerRadius, y: chromeRect.maxY))
        path.addArc(
            center: CGPoint(x: chromeRect.maxX - cornerRadius, y: chromeRect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .pi / 2,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: chromeRect.maxX, y: chromeRect.minY))
        path.closeSubpath()

        context.addPath(path)
        context.fillPath()

        // Traffic lights (macOS style)
        let buttonY = chromeRect.midY
        let buttonRadius: CGFloat = 5.5
        let buttonSpacing: CGFloat = 8
        let leftMargin: CGFloat = 12

        drawCircle(in: context, center: CGPoint(x: leftMargin + buttonRadius, y: buttonY), radius: buttonRadius, color: NSColor(hex: "#FF5F57")!)
        drawCircle(in: context, center: CGPoint(x: leftMargin + buttonRadius + buttonSpacing + buttonRadius * 2, y: buttonY), radius: buttonRadius, color: NSColor(hex: "#FFBD2E")!)
        drawCircle(in: context, center: CGPoint(x: leftMargin + buttonRadius + (buttonSpacing + buttonRadius * 2) * 2, y: buttonY), radius: buttonRadius, color: NSColor(hex: "#28CA42")!)

        // File name (centered)
        let fileName = "code.swift"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12),
            .foregroundColor: isDarkTheme ? NSColor.white : NSColor.black
        ]
        let textSize = fileName.size(withAttributes: attributes)
        let textPoint = CGPoint(
            x: chromeRect.midX - textSize.width / 2,
            y: chromeRect.midY - textSize.height / 2
        )
        fileName.draw(at: textPoint, withAttributes: attributes)
    }

    // MARK: - Terminal Window Chrome

    private func renderTerminalChrome(in context: CGContext, rect: CGRect, cornerRadius: CGFloat, isDarkTheme: Bool) {
        let chromeHeight = Self.terminalChromeHeight
        let chromeRect = CGRect(x: rect.minX, y: rect.maxY - chromeHeight, width: rect.width, height: chromeHeight)

        // Background (terminal header)
        let backgroundColor = isDarkTheme ? NSColor(hex: "#1E1E1E")! : NSColor(hex: "#F5F5F5")!
        context.setFillColor(backgroundColor.cgColor)

        // Rounded top
        let path = CGMutablePath()
        path.move(to: CGPoint(x: chromeRect.minX, y: chromeRect.minY))
        path.addLine(to: CGPoint(x: chromeRect.minX, y: chromeRect.maxY - cornerRadius))
        path.addArc(
            center: CGPoint(x: chromeRect.minX + cornerRadius, y: chromeRect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .pi,
            endAngle: .pi / 2,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: chromeRect.maxX - cornerRadius, y: chromeRect.maxY))
        path.addArc(
            center: CGPoint(x: chromeRect.maxX - cornerRadius, y: chromeRect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .pi / 2,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: chromeRect.maxX, y: chromeRect.minY))
        path.closeSubpath()

        context.addPath(path)
        context.fillPath()

        // Traffic lights
        let buttonY = chromeRect.midY
        let buttonRadius: CGFloat = 5.5
        let buttonSpacing: CGFloat = 8
        let leftMargin: CGFloat = 12

        drawCircle(in: context, center: CGPoint(x: leftMargin + buttonRadius, y: buttonY), radius: buttonRadius, color: NSColor(hex: "#FF5F57")!)
        drawCircle(in: context, center: CGPoint(x: leftMargin + buttonRadius + buttonSpacing + buttonRadius * 2, y: buttonY), radius: buttonRadius, color: NSColor(hex: "#FFBD2E")!)
        drawCircle(in: context, center: CGPoint(x: leftMargin + buttonRadius + (buttonSpacing + buttonRadius * 2) * 2, y: buttonY), radius: buttonRadius, color: NSColor(hex: "#28CA42")!)

        // Terminal prompt
        let prompt = "~ user@macbook"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: 11, weight: .regular),
            .foregroundColor: isDarkTheme ? NSColor(white: 0.7, alpha: 1.0) : NSColor(white: 0.3, alpha: 1.0)
        ]
        let textPoint = CGPoint(
            x: leftMargin + buttonRadius * 2 + (buttonSpacing + buttonRadius * 2) * 2 + 20,
            y: chromeRect.midY - 6
        )
        prompt.draw(at: textPoint, withAttributes: attributes)
    }

    // MARK: - Helper Methods

    private func drawCircle(in context: CGContext, center: CGPoint, radius: CGFloat, color: NSColor) {
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
    }
}
