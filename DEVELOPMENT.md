# CodeSnap - Development Log

## Current Status

**Version:** 1.0.0 (In Development)
**Phase:** Foundation Complete, Core Features In Progress
**Last Updated:** November 18, 2025

## ✅ Completed Components

### Phase 1: Project Foundation ✅

1. **Project Structure** ✅
   - Created comprehensive folder structure
   - Set up proper separation of concerns
   - Organized into App, Models, Views, Services, Rendering layers

2. **Data Models** ✅
   - `Screenshot.swift` - Complete screenshot model with all properties
   - `Theme.swift` - Theme model with 7+ built-in themes
   - `Preset.swift` - Preset model with 8 built-in presets
   - `Settings.swift` - Comprehensive app settings with all configurations
   - All enums and supporting types defined

3. **Core Services** ✅
   - `LanguageDetector.swift` - Intelligent language detection with 30+ languages
   - `ClipboardMonitor.swift` - Background clipboard monitoring
   - `HotkeyManager.swift` - Global keyboard shortcuts
   - `StorageManager.swift` - File I/O and data persistence
   - `ThemeManager.swift` - Theme loading and management
   - `PresetManager.swift` - Preset loading and management

4. **Basic Views** ✅
   - `MenuBarController.swift` - Menu bar integration
   - `MenuBarView.swift` - Menu bar dropdown UI
   - `QuickPreviewWindow.swift` - Quick preview window
   - `SettingsView.swift` - Complete settings interface (4 tabs)
   - `LibraryWindow.swift` - Screenshot library with grid/list views

5. **App Infrastructure** ✅
   - `CodeSnapApp.swift` - SwiftUI app entry point
   - `AppDelegate.swift` - AppKit integration for menu bar
   - `Constants.swift` - Comprehensive app constants
   - `Info.plist` - Proper app configuration
   - `.gitignore` - Git ignore rules
   - `README.md` - Project documentation
   - `SETUP.md` - Setup instructions

## 🚧 In Progress

### Phase 2: Rendering Engine

**Status:** Not started

**Components needed:**
1. `CodeRenderer.swift` - Main rendering pipeline
2. `SyntaxHighlighter.swift` - highlight.js wrapper
3. `WindowDecorator.swift` - Window chrome (macOS, browser, VS Code, terminal)
4. `BackgroundRenderer.swift` - Gradients, solid colors, images
5. `ShadowRenderer.swift` - Shadow effects
6. `WatermarkRenderer.swift` - Free tier watermark
7. `ExportService.swift` - Multi-format export (PNG, JPEG, SVG, PDF)

**Dependencies:**
- highlight.js library (needs to be downloaded)
- CoreGraphics for image rendering
- CoreText for font rendering with ligatures
- Metal for GPU acceleration (optional)

## 📋 TODO

### High Priority (MVP)

1. **Add highlight.js** 🔴
   ```bash
   cd CodeSnap/Resources
   curl -O https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js
   ```

2. **Create Theme JSON Files** 🔴
   - GitHub Light/Dark
   - Dracula
   - Nord
   - Tokyo Night
   - One Dark
   - Monokai Pro
   - (15+ more)

3. **Implement SyntaxHighlighter** 🔴
   - Wrap highlight.js via JavaScriptCore
   - Convert HTML to NSAttributedString
   - Apply theme colors

4. **Build Core Renderer** 🔴
   - Code → Image pipeline
   - Apply theme styling
   - Add padding and spacing
   - Generate PNG output

5. **Add Window Styles** 🟡
   - macOS window chrome (traffic lights)
   - Browser chrome (tabs, address bar)
   - VS Code chrome (title bar)
   - Terminal chrome (prompt)

6. **Background Rendering** 🟡
   - Solid colors
   - Linear gradients
   - Radial gradients (optional)
   - Image backgrounds (optional)
   - Transparent backgrounds

7. **Export System** 🟡
   - PNG export (required)
   - JPEG export (required)
   - SVG export (nice to have)
   - PDF export (nice to have)
   - Multiple size presets

### Medium Priority

8. **Complete Editor Window** 🟡
   - `EditorWindow.swift`
   - `SettingsPanel.swift` - All controls
   - `PreviewPanel.swift` - Live preview
   - `CodeEditor.swift` - Editable code
   - `ThemeSelector.swift` - Visual theme picker

9. **Watermark System** 🟡
   - Add watermark overlay
   - Position control
   - Opacity control
   - Pro version removes watermark

10. **Clipboard Integration** 🟡
    - Copy rendered image to clipboard
    - Auto-copy option
    - Format selection

11. **Share Sheet** 🟡
    - macOS native share sheet
    - Share to Twitter, Messages, etc.
    - Save to file

### Low Priority (Post-MVP)

12. **Animations** 🟢
    - Window transitions
    - Button hover effects
    - Preview updates
    - Success feedback

13. **App Icon** 🟢
    - Design app icon
    - Create all required sizes
    - Add to Assets.xcassets

14. **Code Formatting** 🟢
    - Prettier integration for JS/TS
    - Black for Python
    - gofmt for Go
    - Auto-format button

15. **Advanced Features** 🟢
    - Line highlighting
    - Annotations (arrows, boxes)
    - Custom theme creator
    - Import VS Code themes

## Technical Debt

- [ ] Add error handling throughout
- [ ] Add logging system
- [ ] Add analytics (TelemetryDeck)
- [ ] Add crash reporting
- [ ] Add unit tests
- [ ] Add UI tests
- [ ] Performance optimization
- [ ] Memory leak testing

## Architecture Decisions

### Why SwiftUI + AppKit?
- SwiftUI for modern, declarative UI
- AppKit for menu bar integration (NSStatusItem)
- Best of both worlds

### Why highlight.js?
- Battle-tested syntax highlighter
- Supports 200+ languages
- Easy to integrate via JavaScriptCore
- Active maintenance

### Why Local-Only Processing?
- Privacy: Code never leaves user's Mac
- Speed: No network latency
- Offline: Works without internet
- Security: No data leaks

### Why Lifetime License?
- Simple pricing model
- No recurring payments
- Better conversion than subscription
- Aligns with developer tools market

## Performance Targets

- **Quick Capture:** < 2 seconds from hotkey to preview
- **Rendering:** < 1 second for typical code snippet
- **App Launch:** < 3 seconds cold start
- **Memory:** < 100 MB typical usage
- **CPU:** < 5% idle, < 30% rendering

## File Size Targets

- **App Bundle:** < 20 MB
- **Memory Footprint:** < 100 MB
- **Thumbnail Cache:** < 50 MB
- **Library Metadata:** < 10 MB per 1000 screenshots

## Known Issues

None yet - app not functional yet!

## Development Environment

- **macOS:** 13.0+ (Ventura)
- **Xcode:** 15.0+
- **Swift:** 5.9+
- **Architecture:** Universal (Apple Silicon + Intel)

## Build Commands

```bash
# Debug build
xcodebuild -scheme CodeSnap -configuration Debug

# Release build
xcodebuild -scheme CodeSnap -configuration Release

# Clean
xcodebuild clean

# Test
xcodebuild test -scheme CodeSnap
```

## Distribution Checklist

### Code Signing
- [ ] Set up Apple Developer account
- [ ] Create App ID
- [ ] Create Developer certificate
- [ ] Configure signing in Xcode

### Notarization
- [ ] Enable Hardened Runtime
- [ ] Add entitlements
- [ ] Submit for notarization
- [ ] Staple notarization ticket

### DMG Creation
- [ ] Install create-dmg
- [ ] Create DMG with background
- [ ] Add App icon and Applications link
- [ ] Test installation

### App Store (Optional)
- [ ] Create App Store Connect listing
- [ ] Add screenshots
- [ ] Write description
- [ ] Set pricing
- [ ] Submit for review

## Marketing Prep

- [ ] Create landing page (codesnap.app)
- [ ] Record demo video (60 seconds)
- [ ] Take 20+ example screenshots
- [ ] Write launch tweet thread
- [ ] Prepare ProductHunt submission
- [ ] Email tech bloggers
- [ ] Create press kit

## Launch Checklist

- [ ] All MVP features working
- [ ] Tested on macOS 13, 14, 15
- [ ] No memory leaks
- [ ] No crashes
- [ ] Performance targets met
- [ ] Icon designed
- [ ] DMG created
- [ ] Notarized
- [ ] Landing page live
- [ ] Demo video uploaded
- [ ] ProductHunt scheduled
- [ ] 🚀 LAUNCH!

## Next Steps

### Immediate (This Week)
1. Download and integrate highlight.js
2. Create theme JSON files
3. Build SyntaxHighlighter service
4. Implement basic CodeRenderer
5. Test rendering pipeline

### This Month
1. Complete all window styles
2. Finish export system
3. Build editor window
4. Add watermark
5. Polish UI
6. Create app icon

### Before Launch
1. Extensive testing
2. Fix all bugs
3. Optimize performance
4. Create marketing materials
5. Set up distribution
6. Prepare launch

## Resources

- **Docs:** https://docs.codesnap.app (TODO)
- **Repo:** https://github.com/codesnap/codesnap (TODO)
- **Website:** https://codesnap.app (TODO)
- **Support:** support@codesnap.app

---

**Let's build something amazing! 🚀**
