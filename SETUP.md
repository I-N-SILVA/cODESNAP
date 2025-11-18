# CodeSnap Setup Guide

This guide will help you set up the CodeSnap development environment and build the app.

## Prerequisites

- **macOS 13.0 (Ventura) or later**
- **Xcode 15.0 or later**
- **Swift 5.9 or later**
- **Command Line Tools** (install with `xcode-select --install`)

## Quick Start

### Option 1: Create Xcode Project Manually

Since we're starting from source files, you'll need to create an Xcode project:

1. **Open Xcode**
   ```bash
   open -a Xcode
   ```

2. **Create New Project**
   - File → New → Project
   - Choose "macOS" → "App"
   - Product Name: `CodeSnap`
   - Interface: SwiftUI
   - Language: Swift
   - Bundle Identifier: `com.yourcompany.CodeSnap` (change as needed)
   - Click "Create" and choose this directory

3. **Add Source Files**
   - In Xcode, delete the default `ContentView.swift` and `CodeSnapApp.swift`
   - Drag the `CodeSnap` folder from Finder into Xcode's Project Navigator
   - Make sure "Copy items if needed" is **unchecked**
   - Select "Create groups"
   - Click "Finish"

4. **Configure Project Settings**
   - Select the project in Project Navigator
   - Under "Signing & Capabilities":
     - Choose your Team
     - Enable "Automatically manage signing"
   - Under "Info":
     - Add `Info.plist` from the CodeSnap folder
   - Under "Build Settings":
     - Set "iOS Deployment Target" to 13.0
     - Set "Swift Language Version" to Swift 5

5. **Add Required Capabilities**
   - Click "+ Capability"
   - Add "App Sandbox"
   - Under "App Sandbox", enable:
     - User Selected Files (Read/Write)
     - Downloads Folder (Read/Write)
     - Pictures Folder (Read/Write)
   - Add "Hardened Runtime"

6. **Configure Info.plist**
   - The Info.plist is already configured
   - Key setting: `LSUIElement` is set to `YES` (menu bar only app)

### Option 2: Use Swift Package Manager (SPM)

Alternatively, create a Package.swift:

```swift
// Package.swift
// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CodeSnap",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "CodeSnap",
            targets: ["CodeSnap"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "CodeSnap",
            dependencies: [],
            path: "CodeSnap"
        )
    ]
)
```

Then build with:
```bash
swift build -c release
```

## Project Structure

The project follows this structure:

```
CodeSnap/
├── App/                    # App entry point
│   ├── CodeSnapApp.swift
│   ├── AppDelegate.swift
│   └── Constants.swift
│
├── Models/                 # Data models
│   ├── Screenshot.swift
│   ├── Theme.swift
│   ├── Preset.swift
│   └── Settings.swift
│
├── Services/              # Business logic
│   ├── ClipboardMonitor.swift
│   ├── LanguageDetector.swift
│   ├── HotkeyManager.swift
│   ├── StorageManager.swift
│   ├── ThemeManager.swift
│   └── PresetManager.swift
│
├── Views/                 # UI components
│   ├── MenuBar/
│   ├── Editor/
│   ├── Library/
│   └── Settings/
│
├── Rendering/            # Image rendering (TODO)
├── Resources/            # Assets and themes (TODO)
└── Tests/               # Unit tests (TODO)
```

## Building the App

### Debug Build

```bash
# In Xcode
⌘ + B (or Product → Build)

# Or via command line
xcodebuild -scheme CodeSnap -configuration Debug
```

### Release Build

```bash
# In Xcode
⌘ + Shift + I (or Product → Archive)

# Or via command line
xcodebuild -scheme CodeSnap -configuration Release
```

## Running the App

### From Xcode

1. Select the "CodeSnap" scheme
2. Press `⌘ + R` (or click Run)
3. The app will appear in your menu bar (top-right)

### From Terminal

```bash
# After building
open build/Release/CodeSnap.app
```

## Development Status

### ✅ Completed
- [x] Project structure
- [x] Data models (Screenshot, Theme, Preset, Settings)
- [x] Core services (LanguageDetector, ClipboardMonitor, HotkeyManager)
- [x] Storage management
- [x] Theme management
- [x] Preset management
- [x] Basic UI views (MenuBar, Settings, Library)

### 🚧 In Progress
- [ ] Syntax highlighting integration (highlight.js)
- [ ] Rendering engine
- [ ] Window decorators (macOS, browser, VS Code, terminal)
- [ ] Background rendering
- [ ] Export system (PNG, JPEG, SVG, PDF)
- [ ] Full editor window

### 📋 TODO
- [ ] Add highlight.js library
- [ ] Implement code rendering
- [ ] Create theme JSON files
- [ ] Build editor UI
- [ ] Add watermark rendering
- [ ] Implement all export formats
- [ ] Add animations
- [ ] Create app icon
- [ ] Add unit tests

## Next Steps

### 1. Add highlight.js

Download highlight.js and add to Resources:

```bash
cd CodeSnap/Resources
curl -O https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js
```

### 2. Create Theme JSON Files

Add theme files in `Resources/Themes/`:

- `github-light.json`
- `github-dark.json`
- `dracula.json`
- etc.

### 3. Implement Rendering Engine

Create the rendering engine in `CodeSnap/Rendering/`:

- `CodeRenderer.swift` - Main rendering logic
- `WindowDecorator.swift` - Add window chrome
- `BackgroundRenderer.swift` - Render backgrounds
- `ShadowRenderer.swift` - Add shadows
- `WatermarkRenderer.swift` - Add watermark

### 4. Build Editor Window

Complete the editor UI in `Views/Editor/`:

- `EditorWindow.swift`
- `SettingsPanel.swift`
- `PreviewPanel.swift`
- `CodeEditor.swift`
- `ThemeSelector.swift`

## Troubleshooting

### Issue: "App won't launch"

**Solution:** Check that:
- Signing is configured correctly
- Bundle identifier is unique
- macOS version is 13.0+

### Issue: "Hotkeys don't work"

**Solution:**
1. Go to System Settings → Privacy & Security → Accessibility
2. Add CodeSnap to the list
3. Restart the app

### Issue: "Can't see menu bar icon"

**Solution:**
- Check that `LSUIElement` in Info.plist is `true`
- Verify the app is running (check Activity Monitor)
- Try clicking on the menu bar area (icon might be hidden)

### Issue: "Build errors"

**Solution:**
1. Clean build folder: `⌘ + Shift + K`
2. Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
3. Restart Xcode
4. Rebuild: `⌘ + B`

## Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [AppKit Documentation](https://developer.apple.com/documentation/appkit)
- [highlight.js](https://highlightjs.org/)

## Contributing

This is currently a private project. Theme contributions will be accepted once the app is launched.

## License

Copyright © 2025 CodeSnap. All rights reserved.

## Support

For questions or issues:
- Email: support@codesnap.app
- Website: https://codesnap.app

---

**Happy Coding! 🚀**
