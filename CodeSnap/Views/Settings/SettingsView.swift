//
//  SettingsView.swift
//  CodeSnap
//
//  Main settings window
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: AppSettingsManager
    @State private var selectedTab: SettingsTab = .general

    enum SettingsTab: String, CaseIterable {
        case general = "General"
        case appearance = "Appearance"
        case export = "Export"
        case advanced = "Advanced"

        var icon: String {
            switch self {
            case .general: return "gearshape"
            case .appearance: return "paintbrush"
            case .export: return "square.and.arrow.up"
            case .advanced: return "slider.horizontal.3"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            GeneralSettingsView()
                .tabItem {
                    Label(SettingsTab.general.rawValue, systemImage: SettingsTab.general.icon)
                }
                .tag(SettingsTab.general)

            AppearanceSettingsView()
                .tabItem {
                    Label(SettingsTab.appearance.rawValue, systemImage: SettingsTab.appearance.icon)
                }
                .tag(SettingsTab.appearance)

            ExportSettingsView()
                .tabItem {
                    Label(SettingsTab.export.rawValue, systemImage: SettingsTab.export.icon)
                }
                .tag(SettingsTab.export)

            AdvancedSettingsView()
                .tabItem {
                    Label(SettingsTab.advanced.rawValue, systemImage: SettingsTab.advanced.icon)
                }
                .tag(SettingsTab.advanced)
        }
        .frame(width: Constants.UI.settingsWidth, height: Constants.UI.settingsHeight)
    }
}

// MARK: - General Settings

struct GeneralSettingsView: View {
    @EnvironmentObject var settingsManager: AppSettingsManager

    var body: some View {
        Form {
            Section("Startup") {
                Toggle("Launch at login", isOn: $settingsManager.settings.launchAtLogin)
                Toggle("Show menu bar icon", isOn: $settingsManager.settings.showMenuBarIcon)
                Toggle("Show in Dock", isOn: $settingsManager.settings.showInDock)
            }

            Section("Updates") {
                Toggle("Check for updates automatically", isOn: $settingsManager.settings.autoCheckUpdates)
            }

            Section("Hotkeys") {
                LabeledContent("Quick Capture") {
                    Text(settingsManager.settings.quickCaptureHotkey)
                        .font(.system(.body, design: .monospaced))
                }

                LabeledContent("Open Library") {
                    Text(settingsManager.settings.openLibraryHotkey)
                        .font(.system(.body, design: .monospaced))
                }
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

// MARK: - Appearance Settings

struct AppearanceSettingsView: View {
    @EnvironmentObject var settingsManager: AppSettingsManager

    var body: some View {
        Form {
            Section("App Theme") {
                Picker("Theme", selection: $settingsManager.settings.appTheme) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Text(theme.displayName).tag(theme)
                    }
                }
            }

            Section("Default Screenshot Style") {
                LabeledContent("Theme") {
                    Text(settingsManager.settings.defaultTheme)
                }

                LabeledContent("Window Style") {
                    Text(settingsManager.settings.defaultWindowStyle.displayName)
                }

                LabeledContent("Font") {
                    Text("\(settingsManager.settings.defaultFontFamily) \(Int(settingsManager.settings.defaultFontSize))pt")
                }
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

// MARK: - Export Settings

struct ExportSettingsView: View {
    @EnvironmentObject var settingsManager: AppSettingsManager

    var body: some View {
        Form {
            Section("Default Export") {
                Picker("Format", selection: $settingsManager.settings.defaultExportFormat) {
                    ForEach(ExportFormat.allCases) { format in
                        Text(format.displayName).tag(format)
                    }
                }

                Picker("Size", selection: $settingsManager.settings.defaultExportSize) {
                    Text("1x").tag(1.0)
                    Text("2x (Retina)").tag(2.0)
                    Text("3x").tag(3.0)
                    Text("4x").tag(4.0)
                }
            }

            Section("Auto-actions") {
                Toggle("Auto-copy to clipboard", isOn: $settingsManager.settings.autoCopyToClipboard)
                Toggle("Auto-save to file", isOn: $settingsManager.settings.autoSaveToFile)
                Toggle("Show export notification", isOn: $settingsManager.settings.showExportNotification)
            }

            Section("Watermark") {
                Toggle("Show watermark", isOn: $settingsManager.settings.showWatermark)

                if settingsManager.settings.showWatermark {
                    TextField("Text", text: $settingsManager.settings.watermarkText)

                    Picker("Position", selection: $settingsManager.settings.watermarkPosition) {
                        ForEach(WatermarkPosition.allCases, id: \.self) { position in
                            Text(position.displayName).tag(position)
                        }
                    }
                }

                if !settingsManager.settings.isProVersion {
                    HStack {
                        Text("Remove watermark with Pro")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Button("Upgrade") {
                            // Show upgrade dialog
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                    }
                }
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

// MARK: - Advanced Settings

struct AdvancedSettingsView: View {
    @EnvironmentObject var settingsManager: AppSettingsManager
    @State private var cacheSize: Int64 = 0

    var body: some View {
        Form {
            Section("Storage") {
                LabeledContent("Save Location") {
                    Text(settingsManager.settings.saveLocation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }

                Button("Choose Location...") {
                    chooseLocation()
                }

                Toggle("Auto-save screenshots", isOn: $settingsManager.settings.autoSaveScreenshots)

                Stepper("Keep \(settingsManager.settings.keepHistoryCount) in history",
                       value: $settingsManager.settings.keepHistoryCount,
                       in: 10...1000,
                       step: 10)
            }

            Section("Cache") {
                LabeledContent("Cache Size") {
                    Text(formatBytes(cacheSize))
                }

                Button("Clear Cache") {
                    clearCache()
                }
            }

            Section("Privacy") {
                Toggle("Enable analytics", isOn: $settingsManager.settings.enableAnalytics)
                Toggle("Enable crash reporting", isOn: $settingsManager.settings.enableCrashReporting)
            }

            Section("About") {
                LabeledContent("Version") {
                    Text("\(Constants.appVersion) (\(Constants.appBuildNumber))")
                }

                LabeledContent("License") {
                    if settingsManager.settings.isProVersion {
                        Text("Pro")
                            .foregroundColor(.green)
                    } else {
                        Text("Free")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .formStyle(.grouped)
        .padding()
        .onAppear {
            updateCacheSize()
        }
    }

    private func chooseLocation() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        panel.begin { response in
            if response == .OK, let url = panel.url {
                settingsManager.settings.setSaveLocation(url)
            }
        }
    }

    private func clearCache() {
        try? StorageManager.shared.clearCache()
        updateCacheSize()
    }

    private func updateCacheSize() {
        cacheSize = StorageManager.shared.getCacheSize()
    }

    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}
