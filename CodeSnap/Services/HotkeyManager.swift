//
//  HotkeyManager.swift
//  CodeSnap
//
//  Manage global keyboard shortcuts
//

import Foundation
import Carbon
import AppKit

class HotkeyManager {
    private var hotkeys: [String: EventHotKeyRef?] = [:]
    private var handlers: [String: () -> Void] = [:]
    private static var sharedInstance: HotkeyManager?

    init() {
        Self.sharedInstance = self
    }

    // MARK: - Registration

    func register(hotkey: String, action: @escaping () -> Void) {
        guard let (keyCode, modifiers) = parseHotkey(hotkey) else {
            print("Failed to parse hotkey: \(hotkey)")
            return
        }

        // Store handler
        handlers[hotkey] = action

        // Register system-wide hotkey
        var eventHotKey: EventHotKeyRef?
        let hotkeyID = EventHotKeyID(signature: OSType("CSNP".fourCharCodeValue), id: UInt32(hotkeys.count))

        let status = RegisterEventHotKey(
            UInt32(keyCode),
            UInt32(modifiers),
            hotkeyID,
            GetEventDispatcherTarget(),
            0,
            &eventHotKey
        )

        if status == noErr {
            hotkeys[hotkey] = eventHotKey
            print("Registered hotkey: \(hotkey)")
        } else {
            print("Failed to register hotkey: \(hotkey), status: \(status)")
        }
    }

    func unregister(hotkey: String) {
        if let eventHotKey = hotkeys[hotkey] {
            UnregisterEventHotKey(eventHotKey!)
            hotkeys.removeValue(forKey: hotkey)
            handlers.removeValue(forKey: hotkey)
        }
    }

    func unregisterAll() {
        for (hotkey, _) in hotkeys {
            unregister(hotkey: hotkey)
        }
    }

    // MARK: - Hotkey Parsing

    private func parseHotkey(_ hotkey: String) -> (Int, Int)? {
        // Parse hotkey string like "⌘⇧C" or "Cmd+Shift+C"
        var modifiers: Int = 0
        var keyCode: Int = 0

        // Convert symbols to modifier flags
        if hotkey.contains("⌘") || hotkey.lowercased().contains("cmd") || hotkey.lowercased().contains("command") {
            modifiers |= cmdKey
        }
        if hotkey.contains("⇧") || hotkey.lowercased().contains("shift") {
            modifiers |= shiftKey
        }
        if hotkey.contains("⌥") || hotkey.lowercased().contains("opt") || hotkey.lowercased().contains("alt") {
            modifiers |= optionKey
        }
        if hotkey.contains("⌃") || hotkey.lowercased().contains("ctrl") || hotkey.lowercased().contains("control") {
            modifiers |= controlKey
        }

        // Extract the key character (last character or after last +)
        let components = hotkey.components(separatedBy: "+")
        let keyString = components.last?.uppercased() ?? ""

        // Map key string to key code
        keyCode = keyCodeForString(keyString)

        guard keyCode != -1 else { return nil }

        return (keyCode, modifiers)
    }

    private func keyCodeForString(_ key: String) -> Int {
        let keyCodes: [String: Int] = [
            "A": 0x00, "B": 0x0B, "C": 0x08, "D": 0x02, "E": 0x0E,
            "F": 0x03, "G": 0x05, "H": 0x04, "I": 0x22, "J": 0x26,
            "K": 0x28, "L": 0x25, "M": 0x2E, "N": 0x2D, "O": 0x1F,
            "P": 0x23, "Q": 0x0C, "R": 0x0F, "S": 0x01, "T": 0x11,
            "U": 0x20, "V": 0x09, "W": 0x0D, "X": 0x07, "Y": 0x10,
            "Z": 0x06,
            "0": 0x1D, "1": 0x12, "2": 0x13, "3": 0x14, "4": 0x15,
            "5": 0x17, "6": 0x16, "7": 0x1A, "8": 0x1C, "9": 0x19,
            "SPACE": 0x31, "RETURN": 0x24, "ENTER": 0x24,
            "TAB": 0x30, "DELETE": 0x33, "ESCAPE": 0x35, "ESC": 0x35,
            "F1": 0x7A, "F2": 0x78, "F3": 0x63, "F4": 0x76,
            "F5": 0x60, "F6": 0x61, "F7": 0x62, "F8": 0x64,
            "F9": 0x65, "F10": 0x6D, "F11": 0x67, "F12": 0x6F
        ]

        // Remove symbols like ⌘⇧⌥⌃
        let cleanKey = key.filter { !["⌘", "⇧", "⌥", "⌃"].contains(String($0)) }

        return keyCodes[cleanKey.uppercased()] ?? -1
    }

    // MARK: - Handler Execution

    func executeHandler(for hotkey: String) {
        handlers[hotkey]?()
    }

    static func handleHotkeyEvent(hotkeyID: EventHotKeyID) {
        // Find and execute the handler
        // This is called from Carbon event handler
        guard let manager = sharedInstance else { return }

        // Find hotkey by ID (simplified - in production, maintain ID mapping)
        for (hotkey, handler) in manager.handlers {
            DispatchQueue.main.async {
                handler()
            }
            break // Execute first handler (simplified)
        }
    }
}

// MARK: - String Extension

extension String {
    var fourCharCodeValue: FourCharCode {
        var result: FourCharCode = 0
        for char in self.utf8.prefix(4) {
            result = result << 8 + FourCharCode(char)
        }
        return result
    }
}

// MARK: - Hotkey Display Helpers

extension String {
    /// Convert hotkey string to user-friendly display format
    /// e.g., "⌘⇧C" -> "Command+Shift+C"
    var hotkeyDisplayName: String {
        var display = self
        display = display.replacingOccurrences(of: "⌘", with: "Command+")
        display = display.replacingOccurrences(of: "⇧", with: "Shift+")
        display = display.replacingOccurrences(of: "⌥", with: "Option+")
        display = display.replacingOccurrences(of: "⌃", with: "Control+")

        // Remove trailing +
        if display.hasSuffix("+") {
            display.removeLast()
        }

        return display
    }

    /// Convert display name back to hotkey string
    /// e.g., "Command+Shift+C" -> "⌘⇧C"
    var hotkeySymbolString: String {
        var symbol = self
        symbol = symbol.replacingOccurrences(of: "Command+", with: "⌘")
        symbol = symbol.replacingOccurrences(of: "Cmd+", with: "⌘")
        symbol = symbol.replacingOccurrences(of: "Shift+", with: "⇧")
        symbol = symbol.replacingOccurrences(of: "Option+", with: "⌥")
        symbol = symbol.replacingOccurrences(of: "Opt+", with: "⌥")
        symbol = symbol.replacingOccurrences(of: "Alt+", with: "⌥")
        symbol = symbol.replacingOccurrences(of: "Control+", with: "⌃")
        symbol = symbol.replacingOccurrences(of: "Ctrl+", with: "⌃")

        return symbol
    }
}
