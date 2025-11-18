//
//  CodeSnapApp.swift
//  CodeSnap
//
//  Created on November 18, 2025.
//

import SwiftUI

@main
struct CodeSnapApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appSettings = AppSettingsManager.shared

    var body: some Scene {
        // Settings window (shown when user clicks Settings in menu)
        Settings {
            SettingsView()
                .environmentObject(appSettings)
        }
    }
}

// App Settings Manager (Observable)
class AppSettingsManager: ObservableObject {
    static let shared = AppSettingsManager()

    @Published var settings: AppSettings {
        didSet {
            saveSettings()
        }
    }

    private init() {
        self.settings = Self.loadSettings()
    }

    private static func loadSettings() -> AppSettings {
        guard let data = UserDefaults.standard.data(forKey: "AppSettings"),
              let settings = try? JSONDecoder().decode(AppSettings.self, from: data) else {
            return AppSettings() // Return default settings
        }
        return settings
    }

    private func saveSettings() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        UserDefaults.standard.set(data, forKey: "AppSettings")
    }

    func resetToDefaults() {
        settings = AppSettings()
    }
}
