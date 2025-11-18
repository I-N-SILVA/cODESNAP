//
//  ClipboardMonitor.swift
//  CodeSnap
//
//  Monitor clipboard for code changes
//

import Foundation
import AppKit

class ClipboardMonitor {
    private var timer: Timer?
    private var lastChangeCount: Int = 0
    private var onClipboardChange: ((String) -> Void)?

    // MARK: - Public Methods

    func start(onChange: @escaping (String) -> Void) {
        self.onClipboardChange = onChange
        self.lastChangeCount = NSPasteboard.general.changeCount

        // Poll clipboard every 0.5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        onClipboardChange = nil
    }

    // MARK: - Private Methods

    private func checkClipboard() {
        let currentChangeCount = NSPasteboard.general.changeCount

        // Check if clipboard has changed
        guard currentChangeCount != lastChangeCount else { return }
        lastChangeCount = currentChangeCount

        // Get clipboard content
        guard let content = NSPasteboard.general.string(forType: .string) else { return }

        // Notify callback
        onClipboardChange?(content)
    }
}

// MARK: - Clipboard Utilities

extension NSPasteboard {
    /// Copy text to clipboard
    static func copy(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }

    /// Copy image to clipboard
    static func copy(_ image: NSImage) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([image])
    }

    /// Get current clipboard text
    static var currentText: String? {
        return NSPasteboard.general.string(forType: .string)
    }

    /// Get current clipboard image
    static var currentImage: NSImage? {
        guard let data = NSPasteboard.general.data(forType: .tiff),
              let image = NSImage(data: data) else {
            return nil
        }
        return image
    }
}
