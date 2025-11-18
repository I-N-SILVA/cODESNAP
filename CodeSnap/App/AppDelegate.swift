//
//  AppDelegate.swift
//  CodeSnap
//
//  Menu bar controller and app lifecycle management
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var menuBarController: MenuBarController?
    private var hotkeyManager: HotkeyManager?
    private var clipboardMonitor: ClipboardMonitor?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon (menu bar only app)
        if !AppSettingsManager.shared.settings.showInDock {
            NSApp.setActivationPolicy(.accessory)
        }

        // Set up menu bar
        setupMenuBar()

        // Set up global hotkeys
        setupHotkeys()

        // Start clipboard monitoring (if enabled)
        if AppSettingsManager.shared.settings.enableClipboardMonitoring {
            startClipboardMonitoring()
        }

        // Check for updates (if enabled)
        if AppSettingsManager.shared.settings.autoCheckUpdates {
            checkForUpdates()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Clean up
        hotkeyManager?.unregisterAll()
        clipboardMonitor?.stop()
    }

    // MARK: - Menu Bar Setup

    private func setupMenuBar() {
        // Create status item in menu bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        guard let statusItem = statusItem else { return }

        // Set icon (SF Symbol: chevron.left.forwardslash.chevron.right)
        if let button = statusItem.button {
            let config = NSImage.SymbolConfiguration(pointSize: 14, weight: .medium)
            let image = NSImage(systemSymbolName: "chevron.left.forwardslash.chevron.right", accessibilityDescription: "CodeSnap")
            button.image = image?.withSymbolConfiguration(config)
            button.action = #selector(menuBarButtonClicked)
            button.target = self
        }

        // Create menu bar controller
        menuBarController = MenuBarController(statusItem: statusItem)
    }

    @objc private func menuBarButtonClicked() {
        menuBarController?.toggleMenu()
    }

    // MARK: - Hotkey Setup

    private func setupHotkeys() {
        hotkeyManager = HotkeyManager()

        // Register quick capture hotkey (Cmd+Shift+C)
        hotkeyManager?.register(
            hotkey: AppSettingsManager.shared.settings.quickCaptureHotkey,
            action: { [weak self] in
                self?.performQuickCapture()
            }
        )

        // Register library hotkey (Cmd+Shift+L)
        hotkeyManager?.register(
            hotkey: AppSettingsManager.shared.settings.openLibraryHotkey,
            action: { [weak self] in
                self?.openLibrary()
            }
        )
    }

    // MARK: - Actions

    private func performQuickCapture() {
        // Get code from clipboard
        guard let code = NSPasteboard.general.string(forType: .string) else {
            showNotification(title: "No Code Found", message: "Please copy some code to your clipboard first.")
            return
        }

        // Detect language
        let language = LanguageDetector.shared.detect(code: code)

        // Create screenshot with default settings
        let screenshot = Screenshot(
            code: code,
            language: language,
            theme: AppSettingsManager.shared.settings.defaultTheme,
            windowStyle: AppSettingsManager.shared.settings.defaultWindowStyle,
            backgroundColor: AppSettingsManager.shared.settings.defaultBackground,
            fontSize: AppSettingsManager.shared.settings.defaultFontSize,
            fontFamily: AppSettingsManager.shared.settings.defaultFontFamily,
            padding: AppSettingsManager.shared.settings.defaultPadding,
            shadow: AppSettingsManager.shared.settings.defaultShadow,
            exportSize: AppSettingsManager.shared.settings.defaultExportSize
        )

        // Show quick preview
        showQuickPreview(screenshot: screenshot)
    }

    private func showQuickPreview(screenshot: Screenshot) {
        // Create and show quick preview window
        let previewWindow = QuickPreviewWindow(screenshot: screenshot)
        previewWindow.show()
    }

    private func openLibrary() {
        // Open library window
        let libraryWindow = LibraryWindow()
        libraryWindow.show()
    }

    private func startClipboardMonitoring() {
        clipboardMonitor = ClipboardMonitor()
        clipboardMonitor?.start { [weak self] copiedText in
            // Auto-detect if copied text is code
            if LanguageDetector.shared.looksLikeCode(copiedText) {
                self?.showNotification(
                    title: "Code Detected",
                    message: "Press \(AppSettingsManager.shared.settings.quickCaptureHotkey) to create a beautiful screenshot"
                )
            }
        }
    }

    private func checkForUpdates() {
        // TODO: Implement update checking
        // Will use Sparkle or custom implementation
    }

    // MARK: - Utilities

    private func showNotification(title: String, message: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = message
        notification.soundName = NSUserNotificationDefaultSoundName

        NSUserNotificationCenter.default.deliver(notification)
    }
}
