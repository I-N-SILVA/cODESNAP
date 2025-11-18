//
//  MenuBarView.swift
//  CodeSnap
//
//  Main menu bar dropdown view
//

import SwiftUI

struct MenuBarView: View {
    @StateObject private var storageManager = StorageManager.shared
    @State private var recentScreenshots: [Screenshot] = []

    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerSection

            Divider()

            // Recent screenshots
            if !recentScreenshots.isEmpty {
                recentSection
                Divider()
            }

            // Actions
            actionsSection

            Divider()

            // Footer
            footerSection
        }
        .frame(width: Constants.UI.menuWidth)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            loadRecentScreenshots()
        }
    }

    private var headerSection: some View {
        HStack {
            Image(systemName: "chevron.left.forwardslash.chevron.right")
                .font(.title2)
                .foregroundColor(.accentColor)

            Text("CodeSnap")
                .font(.headline)

            Spacer()

            if !AppSettingsManager.shared.settings.isProVersion {
                Text("Free")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(4)
            }
        }
        .padding()
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.top, 8)

            ScrollView {
                VStack(spacing: 4) {
                    ForEach(recentScreenshots.prefix(Constants.Storage.maxRecentItems)) { screenshot in
                        RecentScreenshotRow(screenshot: screenshot)
                    }
                }
            }
            .frame(maxHeight: 200)
        }
    }

    private var actionsSection: some View {
        VStack(spacing: 4) {
            MenuButton(
                icon: "plus.circle.fill",
                title: "New Screenshot",
                hotkey: "⌘⇧C",
                action: { performQuickCapture() }
            )

            MenuButton(
                icon: "photo.on.rectangle",
                title: "Open Library",
                hotkey: "⌘⇧L",
                action: { openLibrary() }
            )

            MenuButton(
                icon: "gearshape",
                title: "Settings",
                action: { openSettings() }
            )
        }
        .padding(.vertical, 8)
    }

    private var footerSection: some View {
        HStack {
            Button(action: { openAbout() }) {
                Text("About")
                    .font(.caption)
            }
            .buttonStyle(.plain)

            Spacer()

            Button(action: { quitApp() }) {
                Text("Quit CodeSnap")
                    .font(.caption)
            }
            .buttonStyle(.plain)
        }
        .padding()
    }

    // MARK: - Actions

    private func loadRecentScreenshots() {
        if let screenshots = try? StorageManager.shared.loadScreenshots(limit: 10) {
            recentScreenshots = screenshots
        }
    }

    private func performQuickCapture() {
        // Trigger quick capture
        NotificationCenter.default.post(name: .performQuickCapture, object: nil)
    }

    private func openLibrary() {
        // Open library window
        NotificationCenter.default.post(name: .openLibrary, object: nil)
    }

    private func openSettings() {
        // Open settings window
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }

    private func openAbout() {
        NSApp.orderFrontStandardAboutPanel(nil)
    }

    private func quitApp() {
        NSApp.terminate(nil)
    }
}

// MARK: - Menu Button

struct MenuButton: View {
    let icon: String
    let title: String
    var hotkey: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.accentColor)
                    .frame(width: 20)

                Text(title)
                    .font(.body)

                Spacer()

                if let hotkey = hotkey {
                    Text(hotkey)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            Color.accentColor.opacity(0.0)
        )
        .cornerRadius(6)
        .padding(.horizontal, 8)
    }
}

// MARK: - Recent Screenshot Row

struct RecentScreenshotRow: View {
    let screenshot: Screenshot

    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail placeholder
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.secondary.opacity(0.2))
                .frame(width: 60, height: 40)
                .overlay(
                    Image(systemName: "chevron.left.forwardslash.chevron.right")
                        .foregroundColor(.secondary)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(screenshot.firstTwoLines)
                    .font(.system(.caption, design: .monospaced))
                    .lineLimit(2)
                    .foregroundColor(.primary)

                HStack(spacing: 8) {
                    Label(screenshot.language, systemImage: "doc.text")
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    Text(screenshot.createdAt, style: .relative)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
        .cornerRadius(6)
        .padding(.horizontal, 8)
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let performQuickCapture = Notification.Name("performQuickCapture")
    static let openLibrary = Notification.Name("openLibrary")
}
