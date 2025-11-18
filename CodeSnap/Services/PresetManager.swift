//
//  PresetManager.swift
//  CodeSnap
//
//  Manage presets and provide preset-related functionality
//

import Foundation
import SwiftUI

class PresetManager: ObservableObject {
    static let shared = PresetManager()

    @Published var presets: [Preset] = []
    @Published var selectedPreset: Preset?

    private let storage = StorageManager.shared

    private init() {
        loadPresets()
    }

    // MARK: - Preset Loading

    func loadPresets() {
        var allPresets: [Preset] = []

        // Add built-in presets
        allPresets.append(contentsOf: Preset.builtInPresets)

        // Load custom presets
        if let customPresets = try? storage.loadPresets() {
            allPresets.append(contentsOf: customPresets)
        }

        self.presets = allPresets.sorted { preset1, preset2 in
            // Built-in presets first
            if preset1.isBuiltIn && !preset2.isBuiltIn {
                return true
            }
            if !preset1.isBuiltIn && preset2.isBuiltIn {
                return false
            }
            // Then by creation date
            return preset1.createdAt > preset2.createdAt
        }
    }

    // MARK: - Preset Selection

    func selectPreset(_ preset: Preset) {
        selectedPreset = preset
    }

    func selectPreset(named name: String) {
        if let preset = presets.first(where: { $0.name == name }) {
            selectedPreset = preset
        }
    }

    func clearSelection() {
        selectedPreset = nil
    }

    // MARK: - Preset Management

    func savePreset(_ preset: Preset) throws {
        var newPreset = preset
        newPreset.isBuiltIn = false

        try storage.savePreset(newPreset)
        loadPresets()
    }

    func createPreset(from screenshot: Screenshot, name: String, emoji: String) throws {
        let preset = Preset.from(screenshot: screenshot, name: name, emoji: emoji)
        try savePreset(preset)
    }

    func updatePreset(_ preset: Preset) throws {
        guard !preset.isBuiltIn else {
            throw StorageError.cannotDeleteBuiltIn
        }

        try storage.savePreset(preset)
        loadPresets()
    }

    func deletePreset(_ preset: Preset) throws {
        guard !preset.isBuiltIn else {
            throw StorageError.cannotDeleteBuiltIn
        }

        try storage.deletePreset(preset)
        loadPresets()
    }

    func duplicatePreset(_ preset: Preset, newName: String) -> Preset {
        Preset(
            name: newName,
            emoji: preset.emoji,
            theme: preset.theme,
            windowStyle: preset.windowStyle,
            backgroundColor: preset.backgroundColor,
            fontSize: preset.fontSize,
            fontFamily: preset.fontFamily,
            lineHeight: preset.lineHeight,
            padding: preset.padding,
            shadow: preset.shadow,
            exportSize: preset.exportSize,
            borderRadius: preset.borderRadius,
            showLineNumbers: preset.showLineNumbers,
            enableLigatures: preset.enableLigatures,
            isBuiltIn: false
        )
    }

    // MARK: - Preset Application

    func applyPreset(_ preset: Preset, to screenshot: inout Screenshot) {
        preset.applyTo(screenshot: &screenshot)
    }

    // MARK: - Preset Utilities

    func getPreset(by id: UUID) -> Preset? {
        presets.first { $0.id == id }
    }

    func getPreset(named name: String) -> Preset? {
        presets.first { $0.name == name }
    }

    func getBuiltInPresets() -> [Preset] {
        presets.filter { $0.isBuiltIn }
    }

    func getCustomPresets() -> [Preset] {
        presets.filter { !$0.isBuiltIn }
    }

    func getPresetsWithHotkeys() -> [Preset] {
        presets.filter { $0.hotkey != nil }
    }

    // MARK: - Hotkey Management

    func assignHotkey(_ hotkey: String, to preset: Preset) throws {
        // Check if hotkey is already in use
        if presets.contains(where: { $0.hotkey == hotkey && $0.id != preset.id }) {
            throw PresetError.hotkeyInUse
        }

        var updatedPreset = preset
        updatedPreset.hotkey = hotkey

        try updatePreset(updatedPreset)
    }

    func removeHotkey(from preset: Preset) throws {
        var updatedPreset = preset
        updatedPreset.hotkey = nil

        try updatePreset(updatedPreset)
    }

    // MARK: - Import/Export

    func exportPresetToJSON(_ preset: Preset) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(preset)
        return String(data: data, encoding: .utf8)!
    }

    func importPresetFromJSON(_ jsonString: String) throws -> Preset {
        let data = jsonString.data(using: .utf8)!
        var preset = try JSONDecoder().decode(Preset.self, from: data)
        preset.isBuiltIn = false
        return preset
    }

    func exportAllCustomPresets() throws -> String {
        let customPresets = getCustomPresets()
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(customPresets)
        return String(data: data, encoding: .utf8)!
    }

    func importPresets(from jsonString: String) throws -> [Preset] {
        let data = jsonString.data(using: .utf8)!
        var presets = try JSONDecoder().decode([Preset].self, from: data)

        // Mark all as custom
        for i in 0..<presets.count {
            presets[i].isBuiltIn = false
        }

        // Save all presets
        for preset in presets {
            try storage.savePreset(preset)
        }

        loadPresets()
        return presets
    }
}

// MARK: - Preset Error

enum PresetError: Error {
    case hotkeyInUse
    case invalidName
    case alreadyExists

    var localizedDescription: String {
        switch self {
        case .hotkeyInUse:
            return "This hotkey is already assigned to another preset"
        case .invalidName:
            return "The preset name is invalid"
        case .alreadyExists:
            return "A preset with this name already exists"
        }
    }
}

// MARK: - Preset Extensions

extension Preset {
    /// Get a user-friendly description of the preset
    var description: String {
        """
        \(emoji) \(name)
        Theme: \(theme)
        Window: \(windowStyle.displayName)
        Font: \(fontFamily) \(Int(fontSize))pt
        """
    }

    /// Get a summary of the preset settings
    var summary: String {
        var parts: [String] = []

        parts.append(theme)
        parts.append(windowStyle.displayName)
        parts.append("\(Int(fontSize))pt")

        if shadow.enabled {
            parts.append("Shadow")
        }

        return parts.joined(separator: " • ")
    }
}
