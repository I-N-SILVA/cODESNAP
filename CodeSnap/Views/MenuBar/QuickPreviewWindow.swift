//
//  QuickPreviewWindow.swift
//  CodeSnap
//
//  Quick preview window for instant screenshot review
//

import SwiftUI
import AppKit

class QuickPreviewWindow {
    private var window: NSWindow?
    private let screenshot: Screenshot

    init(screenshot: Screenshot) {
        self.screenshot = screenshot
    }

    func show() {
        let contentView = QuickPreviewView(
            screenshot: screenshot,
            onClose: { [weak self] in
                self?.close()
            },
            onEdit: { [weak self] in
                self?.openEditor()
            }
        )

        let hostingController = NSHostingController(rootView: contentView)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.contentViewController = hostingController
        window.isReleasedWhenClosed = false
        window.level = .floating
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = true
        window.center()
        window.makeKeyAndOrderFront(nil)

        // Add visual effect background
        let visualEffect = NSVisualEffectView()
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .hudWindow

        self.window = window

        // Auto-close after 30 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
            self?.close()
        }
    }

    func close() {
        window?.close()
        window = nil
    }

    private func openEditor() {
        // Open full editor with this screenshot
        // TODO: Implement editor window
        close()
    }
}

// MARK: - Quick Preview View

struct QuickPreviewView: View {
    let screenshot: Screenshot
    let onClose: () -> Void
    let onEdit: () -> Void

    @State private var renderedImage: NSImage?
    @State private var isRendering = true

    var body: some View {
        VStack(spacing: 0) {
            // Header
            header

            // Preview
            preview

            // Actions
            actions
        }
        .frame(width: 600, height: 400)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(16)
        .shadow(radius: 24)
        .onAppear {
            renderScreenshot()
        }
    }

    private var header: some View {
        HStack {
            Button(action: onEdit) {
                Image(systemName: "arrow.left")
            }
            .buttonStyle(.borderless)

            Text(screenshot.language.capitalized)
                .font(.headline)

            Spacer()

            Button(action: copyToClipboard) {
                Label("Copy", systemImage: "doc.on.doc")
            }
            .buttonStyle(.borderedProminent)

            Button(action: onClose) {
                Image(systemName: "xmark")
            }
            .buttonStyle(.borderless)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
    }

    private var preview: some View {
        Group {
            if isRendering {
                ProgressView("Rendering...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let image = renderedImage {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else {
                Text("Failed to render")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    private var actions: some View {
        HStack(spacing: 12) {
            Button("Save") {
                saveToFile()
            }

            Button("Share") {
                shareImage()
            }

            Spacer()

            Button("Edit More...") {
                onEdit()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
    }

    // MARK: - Actions

    private func renderScreenshot() {
        isRendering = true

        Task {
            do {
                // Use actual CodeRenderer
                let image = try await CodeRenderer.shared.render(screenshot: screenshot)

                await MainActor.run {
                    renderedImage = image
                    isRendering = false
                }

                // Auto-save if enabled
                if AppSettingsManager.shared.settings.autoSaveScreenshots {
                    try? await saveScreenshotToLibrary(image: image)
                }
            } catch {
                await MainActor.run {
                    isRendering = false
                    showNotification(title: "Render Failed", message: error.localizedDescription)
                }
            }
        }
    }

    private func saveScreenshotToLibrary(image: NSImage) async throws {
        _ = try StorageManager.shared.saveScreenshot(screenshot, image: image)
    }

    private func copyToClipboard() {
        guard let image = renderedImage else { return }
        NSPasteboard.copy(image)

        // Show notification
        showNotification(title: "Copied!", message: "Screenshot copied to clipboard")
    }

    private func saveToFile() {
        guard let image = renderedImage else { return }

        let panel = NSSavePanel()
        panel.nameFieldStringValue = screenshot.filename
        panel.allowedContentTypes = [.png]

        panel.begin { response in
            if response == .OK, let url = panel.url {
                try? StorageManager.shared.saveImage(image, to: url)
                showNotification(title: "Saved!", message: "Screenshot saved to \(url.lastPathComponent)")
            }
        }
    }

    private func shareImage() {
        guard let image = renderedImage else { return }

        let picker = NSSharingServicePicker(items: [image])
        if let view = NSApp.keyWindow?.contentView {
            picker.show(relativeTo: .zero, of: view, preferredEdge: .minY)
        }
    }

    private func showNotification(title: String, message: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = message
        NSUserNotificationCenter.default.deliver(notification)
    }
}
