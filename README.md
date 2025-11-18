# CodeSnap

**Beautiful code screenshots in seconds.**

CodeSnap is a premium macOS menu bar application that transforms code into beautiful, shareable images. Designed for developers who share code on Twitter, GitHub, blogs, and documentation.

## Features

- ⚡ **Lightning Fast**: Capture beautiful screenshots with Cmd+Shift+C
- 🎨 **20+ Themes**: GitHub, Dracula, Nord, Tokyo Night, and more
- 🪟 **Window Styles**: macOS, VS Code, Browser, Terminal chrome
- 🎯 **Smart Detection**: Auto-detects 200+ programming languages
- 📚 **Library**: Organize and manage your screenshot collection
- 💾 **Multi-Format**: Export as PNG, JPEG, SVG, or PDF
- 🔒 **Private**: 100% local processing, code never leaves your Mac

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later (for development)

## Development Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd cODESNAP
```

### 2. Open in Xcode

```bash
open CodeSnap.xcodeproj
```

### 3. Build and Run

- Select "CodeSnap" scheme
- Press Cmd+R to build and run
- The app will appear in your menu bar

## Project Structure

```
CodeSnap/
├── App/                          # App entry point and configuration
│   ├── CodeSnapApp.swift         # SwiftUI App entry
│   ├── AppDelegate.swift         # AppKit delegate for menu bar
│   └── Constants.swift           # App-wide constants
│
├── Models/                       # Data models
│   ├── Screenshot.swift          # Screenshot model
│   ├── Theme.swift              # Theme model
│   ├── Preset.swift             # Preset model
│   └── Settings.swift           # App settings
│
├── Views/                        # SwiftUI views
│   ├── MenuBar/                 # Menu bar UI
│   ├── Editor/                  # Main editor window
│   ├── Library/                 # Screenshot library
│   ├── Settings/                # Settings window
│   └── Components/              # Reusable components
│
├── Services/                     # Business logic
│   ├── ClipboardMonitor.swift   # Monitor pasteboard
│   ├── LanguageDetector.swift   # Auto-detect language
│   ├── SyntaxHighlighter.swift  # Syntax highlighting
│   ├── HotkeyManager.swift      # Global shortcuts
│   └── ...
│
├── Rendering/                    # Image rendering
│   ├── CodeRenderer.swift       # Main renderer
│   ├── WindowDecorator.swift    # Window chrome
│   ├── BackgroundRenderer.swift # Backgrounds
│   └── ...
│
└── Resources/                    # Assets and data
    ├── Themes/                  # Built-in themes (JSON)
    ├── Presets/                 # Default presets
    └── Assets.xcassets/         # Images and icons
```

## Architecture

### Tech Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI + AppKit (menu bar)
- **Syntax Highlighting**: highlight.js (via JavaScriptCore)
- **Image Rendering**: CoreGraphics + Metal
- **Storage**: UserDefaults + FileManager

### Key Components

1. **Menu Bar Controller**: Always-accessible menu bar interface
2. **Rendering Engine**: Converts code to beautiful images
3. **Theme System**: Manages syntax highlighting themes
4. **Language Detector**: Auto-detects programming languages
5. **Export Service**: Multi-format export (PNG, JPG, SVG, PDF)

## Building for Distribution

### Code Signing

1. Configure your development team in Xcode
2. Select "Automatically manage signing"
3. Or use manual signing with provisioning profiles

### Creating a DMG

```bash
# Build release version
xcodebuild -scheme CodeSnap -configuration Release

# Create DMG (requires create-dmg)
create-dmg \
  --volname "CodeSnap" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --app-drop-link 600 185 \
  "CodeSnap-1.0.dmg" \
  "build/Release/CodeSnap.app"
```

### Notarization

```bash
# Submit for notarization
xcrun notarytool submit CodeSnap-1.0.dmg \
  --apple-id "your@email.com" \
  --team-id "TEAM_ID" \
  --password "app-specific-password" \
  --wait

# Staple the notarization ticket
xcrun stapler staple CodeSnap-1.0.dmg
```

## Development Roadmap

### Version 1.0 (Current)
- [x] Project setup
- [ ] Menu bar controller
- [ ] Core rendering engine
- [ ] Theme system
- [ ] Quick capture
- [ ] Full editor
- [ ] Export system
- [ ] Library management

### Version 1.1
- [ ] Custom themes UI
- [ ] Line highlighting
- [ ] Code formatting (Prettier)
- [ ] More themes

### Version 1.2
- [ ] Annotations (arrows, boxes)
- [ ] Import VS Code themes
- [ ] Browser extension

### Version 2.0
- [ ] iOS companion app
- [ ] iCloud sync
- [ ] GIF/Video export
- [ ] AI features

## Contributing

This is a proprietary project, but theme contributions are welcome!

1. Create a new theme JSON in `Resources/Themes/`
2. Follow the theme schema
3. Submit a pull request

## License

Copyright © 2025 CodeSnap. All rights reserved.

**Themes**: MIT License (open source)
**App**: Proprietary

## Support

- **Website**: https://codesnap.app
- **Email**: support@codesnap.app
- **Twitter**: @CodeSnapApp

## Acknowledgments

- highlight.js for syntax highlighting
- All the amazing theme creators
- The developer community

---

**Made with ❤️ for developers who care about beautiful code**
