//
//  EditorWindow.swift
//  CodeSnap
//
//  Full-featured editor window with live preview
//

import SwiftUI
import AppKit

class EditorWindow {
    private var window: NSWindow?
    private var screenshot: Screenshot

    init(screenshot: Screenshot) {
        self.screenshot = screenshot
    }

    func show() {
        if let window = window {
            window.makeKeyAndOrderFront(nil)
            return
        }

        let contentView = EditorView(screenshot: screenshot)
        let hostingController = NSHostingController(rootView: contentView)

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: Constants.UI.editorWidth, height: Constants.UI.editorHeight),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )

        window.title = "CodeSnap Editor"
        window.contentViewController = hostingController
        window.minSize = NSSize(width: Constants.UI.editorMinWidth, height: Constants.UI.editorMinHeight)
        window.center()
        window.makeKeyAndOrderFront(nil)
        window.isReleasedWhenClosed = false

        self.window = window
    }

    func close() {
        window?.close()
    }
}

// MARK: - Editor View

struct EditorView: View {
    @State var screenshot: Screenshot
    @State private var renderedImage: NSImage?
    @State private var isRendering = false
    @State private var selectedTab: EditorTab = .code

    enum EditorTab {
        case code, style, window, export
    }

    var body: some View {
        HSplitView {
            // Left: Settings Panel
            settingsPanel
                .frame(width: Constants.UI.settingsPanelWidth)

            // Right: Live Preview
            previewPanel
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            renderPreview()
        }
    }

    // MARK: - Settings Panel

    private var settingsPanel: some View {
        VStack(spacing: 0) {
            // Tab selector
            Picker("", selection: $selectedTab) {
                Label("Code", systemImage: "chevron.left.forwardslash.chevron.right").tag(EditorTab.code)
                Label("Style", systemImage: "paintbrush").tag(EditorTab.style)
                Label("Window", systemImage: "macwindow").tag(EditorTab.window)
                Label("Export", systemImage: "square.and.arrow.up").tag(EditorTab.export)
            }
            .pickerStyle(.segmented)
            .padding()

            Divider()

            // Settings content
            ScrollView {
                VStack(spacing: 20) {
                    switch selectedTab {
                    case .code:
                        codeSettings
                    case .style:
                        styleSettings
                    case .window:
                        windowSettings
                    case .export:
                        exportSettings
                    }
                }
                .padding()
            }
        }
        .background(Color(NSColor.controlBackgroundColor))
    }

    // MARK: - Code Settings

    private var codeSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Code Settings")
                .font(.headline)

            // Language
            Picker("Language", selection: $screenshot.language) {
                Text("Auto-detect").tag("auto")
                Divider()
                ForEach(LanguageDetector.shared.getAllSupportedLanguages(), id: \.self) { lang in
                    Text(LanguageDetector.shared.getDisplayName(for: lang)).tag(lang)
                }
            }
            .onChange(of: screenshot.language) { _ in renderPreview() }

            // Font
            HStack {
                Text("Font")
                Spacer()
                Picker("", selection: $screenshot.fontFamily) {
                    Text("JetBrains Mono").tag("JetBrains Mono")
                    Text("Fira Code").tag("Fira Code")
                    Text("SF Mono").tag("SF Mono")
                    Text("Menlo").tag("Menlo")
                    Text("Monaco").tag("Monaco")
                    Text("Courier New").tag("Courier New")
                }
                .frame(width: 150)
            }
            .onChange(of: screenshot.fontFamily) { _ in renderPreview() }

            // Font size
            VStack(alignment: .leading) {
                HStack {
                    Text("Font Size: \(Int(screenshot.fontSize))pt")
                    Spacer()
                }
                Slider(value: $screenshot.fontSize, in: 12...24, step: 1)
            }
            .onChange(of: screenshot.fontSize) { _ in renderPreview() }

            // Line height
            VStack(alignment: .leading) {
                HStack {
                    Text("Line Height: \(String(format: "%.1f", screenshot.lineHeight))")
                    Spacer()
                }
                Slider(value: $screenshot.lineHeight, in: 1.2...2.0, step: 0.1)
            }
            .onChange(of: screenshot.lineHeight) { _ in renderPreview() }

            // Show line numbers
            Toggle("Show line numbers", isOn: $screenshot.showLineNumbers)
                .onChange(of: screenshot.showLineNumbers) { _ in renderPreview() }

            // Enable ligatures
            Toggle("Enable ligatures", isOn: $screenshot.enableLigatures)
                .onChange(of: screenshot.enableLigatures) { _ in renderPreview() }
        }
    }

    // MARK: - Style Settings

    private var styleSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Style Settings")
                .font(.headline)

            // Theme selector
            VStack(alignment: .leading) {
                Text("Theme")
                    .font(.subheadline)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(ThemeManager.shared.themes.prefix(8), id: \.id) { theme in
                        ThemeButton(theme: theme, isSelected: screenshot.theme == theme.name) {
                            screenshot.theme = theme.name
                            renderPreview()
                        }
                    }
                }
            }

            // Padding
            VStack(alignment: .leading) {
                HStack {
                    Text("Padding: \(Int(screenshot.padding))pt")
                    Spacer()
                }
                Slider(value: $screenshot.padding, in: 16...80, step: 4)
            }
            .onChange(of: screenshot.padding) { _ in renderPreview() }

            // Border radius
            VStack(alignment: .leading) {
                HStack {
                    Text("Border Radius: \(Int(screenshot.borderRadius))pt")
                    Spacer()
                }
                Slider(value: $screenshot.borderRadius, in: 0...24, step: 2)
            }
            .onChange(of: screenshot.borderRadius) { _ in renderPreview() }
        }
    }

    // MARK: - Window Settings

    private var windowSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Window Settings")
                .font(.headline)

            // Window style
            Picker("Window Style", selection: $screenshot.windowStyle) {
                ForEach(WindowStyle.allCases) { style in
                    Label(style.displayName, systemImage: style.icon).tag(style)
                }
            }
            .onChange(of: screenshot.windowStyle) { _ in renderPreview() }

            // Background
            Text("Background")
                .font(.subheadline)

            VStack(spacing: 8) {
                Button("Solid Color") {
                    screenshot.backgroundColor = .solid("#667eea")
                    renderPreview()
                }

                Button("Gradient") {
                    screenshot.backgroundColor = .gradient("#667eea", "#764ba2")
                    renderPreview()
                }

                Button("Transparent") {
                    screenshot.backgroundColor = .transparent
                    renderPreview()
                }
            }

            // Shadow
            Toggle("Enable shadow", isOn: $screenshot.shadow.enabled)
                .onChange(of: screenshot.shadow.enabled) { _ in renderPreview() }

            if screenshot.shadow.enabled {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Shadow Size: \(Int(screenshot.shadow.size))pt")
                        Spacer()
                    }
                    Slider(value: $screenshot.shadow.size, in: 0...80, step: 4)
                }
                .onChange(of: screenshot.shadow.size) { _ in renderPreview() }
            }
        }
    }

    // MARK: - Export Settings

    private var exportSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Export Settings")
                .font(.headline)

            // Export size
            Picker("Size", selection: $screenshot.exportSize) {
                Text("1x").tag(1.0)
                Text("2x (Retina)").tag(2.0)
                Text("3x").tag(3.0)
                Text("4x").tag(4.0)
            }
            .onChange(of: screenshot.exportSize) { _ in renderPreview() }

            Divider()

            // Actions
            VStack(spacing: 12) {
                Button(action: copyToClipboard) {
                    Label("Copy to Clipboard", systemImage: "doc.on.doc")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button(action: saveToFile) {
                    Label("Save to File", systemImage: "arrow.down.doc")
                        .frame(maxWidth: .infinity)
                }

                Button(action: share) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    // MARK: - Preview Panel

    private var previewPanel: some View {
        VStack {
            if isRendering {
                ProgressView("Rendering...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let image = renderedImage {
                ScrollView([.horizontal, .vertical]) {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
            } else {
                Text("Preview will appear here")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Actions

    private func renderPreview() {
        isRendering = true

        Task {
            do {
                let image = try await CodeRenderer.shared.render(screenshot: screenshot)
                await MainActor.run {
                    renderedImage = image
                    isRendering = false
                }
            } catch {
                await MainActor.run {
                    isRendering = false
                }
            }
        }
    }

    private func copyToClipboard() {
        guard let image = renderedImage else { return }
        ExportService.shared.copyToClipboard(image: image)
    }

    private func saveToFile() {
        guard let image = renderedImage else { return }

        let panel = NSSavePanel()
        panel.nameFieldStringValue = screenshot.filename
        panel.allowedContentTypes = [.png]

        panel.begin { response in
            if response == .OK, let url = panel.url {
                try? ExportService.shared.export(image: image, format: .png, to: url)
            }
        }
    }

    private func share() {
        guard let image = renderedImage,
              let view = NSApp.keyWindow?.contentView else { return }
        ExportService.shared.share(image: image, from: view)
    }
}

// MARK: - Theme Button

struct ThemeButton: View {
    let theme: Theme
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: theme.colors.background))
                    .frame(height: 60)
                    .overlay(
                        Text("Aa")
                            .foregroundColor(Color(hex: theme.colors.foreground))
                    )

                Text(theme.displayName)
                    .font(.caption)
                    .lineLimit(1)
            }
            .padding(4)
            .background(isSelected ? Color.accentColor.opacity(0.2) : Color.clear)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
