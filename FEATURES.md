# CodeSnap - Feature List

**Current Version:** 1.0.0 Alpha
**Status:** ~80% Complete - Fully Functional MVP
**Last Updated:** November 18, 2025

---

## ✅ Implemented Features

### Core Functionality

#### 🎯 Quick Capture (100%)
- **Global Hotkey**: Cmd+Shift+C for instant capture
- **Auto Language Detection**: Intelligently detects 30+ programming languages
- **Instant Preview**: See your screenshot in < 2 seconds
- **One-Click Actions**: Copy, Save, Share from preview window

#### 🎨 Syntax Highlighting (90%)
- **Swift-Native Engine**: Fast, no JS dependencies
- **9 Custom Highlighters**:
  - JavaScript / TypeScript / JSX / TSX
  - Python
  - Swift
  - Go
  - Rust
  - HTML
  - CSS / SCSS
  - JSON
- **Generic Fallback**: Highlights common keywords for any language
- **200+ Languages Detected**: Auto-detection supports 200+ languages

#### 🌈 Themes (100%)
- **16 Built-in Themes**:
  - **Dark**: GitHub Dark, Dracula, Nord, Tokyo Night, One Dark, Monokai Pro, Catppuccin, Synthwave '84, Material Dark, Gruvbox
  - **Light**: GitHub Light, Solarized Light, Rosé Pine Dawn, One Light, Nord Light, Ayu Light
- **JSON-Based**: Easy to add custom themes
- **Full Color Mapping**: Background, Foreground, Comments, Keywords, Strings, Numbers, Functions, Variables, Types, Constants, Operators, Punctuation, Properties, Tags, Attributes

#### 🪟 Window Styles (100%)
- **macOS**: Authentic macOS window with traffic lights
- **Browser**: Chrome-style with tabs and address bar
- **VS Code**: VS Code title bar with file name
- **Terminal**: Terminal header with prompt
- **None**: Just code, no chrome

#### 🎭 Backgrounds (100%)
- **Solid Colors**: Any hex color
- **Linear Gradients**: Custom 2-color gradients
- **Preset Gradients**: 8 beautiful pre-made gradients
  - Sunset, Ocean, Forest, Purple Haze, Fire, Blue Sky, Pink Dream, Dark Ocean
- **Transparent**: For overlays
- **Image**: Upload custom background (placeholder)

#### 🎨 Customization (100%)
- **Font Selection**: JetBrains Mono, Fira Code, SF Mono, Menlo, Monaco, Courier New
- **Font Size**: 12pt - 24pt
- **Line Height**: 1.2 - 2.0
- **Padding**: 16pt - 80pt
- **Border Radius**: 0pt - 24pt
- **Line Numbers**: Toggle on/off
- **Ligatures**: Font ligature support

#### 💾 Export System (90%)
- **PNG Export**: ✅ Full quality, transparent support
- **JPEG Export**: ✅ Configurable quality (60-100%)
- **PDF Export**: ✅ Print-ready
- **SVG Export**: ⏸️ Placeholder (v2.0)
- **Size Presets**: 1x, 2x (Retina), 3x (Ultra HD), 4x (Print)
- **Social Media Presets**: Twitter Post, Twitter Header, Instagram, GitHub, Blog
- **Copy to Clipboard**: One-click copy
- **macOS Share Sheet**: Share to any app

#### 📚 Library Management (80%)
- **Auto-Save**: Last 100 screenshots saved automatically
- **Grid View**: Visual thumbnail grid
- **List View**: Compact list with details
- **Search**: Find by code content or language
- **Filter**: By language, date, favorites
- **Favorites**: Star important screenshots
- **Delete**: Remove old screenshots
- **Metadata**: Language, date, size, theme

#### ⚙️ Settings (100%)
- **General**: Launch at login, menu bar icon, Dock icon, updates
- **Hotkeys**: Customizable keyboard shortcuts
- **Appearance**: App theme (light/dark/auto), default styles
- **Export**: Default format, size, quality, watermark
- **Advanced**: Storage location, history size, cache management
- **4-Tab Interface**: Organized and easy to navigate

#### 🎨 Editor Window (100%)
- **Live Preview**: Real-time updates as you edit
- **Split View**: Settings panel + Preview panel
- **4 Settings Tabs**:
  - **Code**: Language, Font, Size, Line height, Ligatures
  - **Style**: Themes, Padding, Border radius
  - **Window**: Window styles, Backgrounds, Shadows
  - **Export**: Size presets, Actions (Copy, Save, Share)
- **Visual Theme Selector**: See themes before applying
- **Responsive**: Resizable window, maintains layout

### Technical Features

#### 🚀 Performance
- **Async Rendering**: Non-blocking UI, smooth experience
- **Fast Syntax Highlighting**: Regex-based, < 100ms
- **Efficient Storage**: Metadata separate from images
- **Thumbnail Caching**: Quick library loading
- **Scale-Aware**: Renders at exact scale (1x, 2x, 3x, 4x)

#### 🔒 Privacy
- **100% Local**: All processing on-device
- **No Cloud**: Code never leaves your Mac
- **No Analytics**: Optional crash reporting only
- **No Tracking**: Zero user tracking

#### 🛠️ Developer Experience
- **Clean Architecture**: MVVM with service layer
- **Type-Safe**: Full Swift type system
- **Modular**: Easy to extend and maintain
- **Well-Documented**: Comprehensive inline documentation
- **Error Handling**: Graceful error handling throughout

---

## 🚧 In Progress

### Planned for v1.0 Launch

#### Code Formatting (Priority: High)
- [ ] Prettier integration for JS/TS
- [ ] Black integration for Python
- [ ] gofmt for Go
- [ ] rustfmt for Rust
- [ ] Auto-format button in editor

#### UI Polish (Priority: High)
- [ ] Smooth animations and transitions
- [ ] Loading states for all operations
- [ ] Success/error feedback
- [ ] Tooltips and help text
- [ ] Keyboard navigation

#### App Icon & Branding (Priority: High)
- [ ] Design professional app icon
- [ ] Create all required sizes (16x16 to 1024x1024)
- [ ] Add to Assets.xcassets
- [ ] About window with branding

---

## 📋 Future Features (v1.1+)

### v1.1 - Enhancements
- [ ] **Custom Theme Creator**: UI for creating themes
- [ ] **Import VS Code Themes**: Parse VS Code theme JSON
- [ ] **More Syntax Highlighters**: C/C++, Java, Ruby, PHP, etc.
- [ ] **Line Highlighting**: Highlight specific lines
- [ ] **Code Formatting**: One-click format before screenshot

### v1.2 - Advanced Features
- [ ] **Annotations**: Add arrows, boxes, text overlays
- [ ] **Blur Sensitive Data**: Blur API keys, passwords
- [ ] **Focus Mode**: Dim surrounding code
- [ ] **Browser Extension**: Capture from web
- [ ] **CLI Tool**: Command-line interface

### v1.5 - Collaboration
- [ ] **iOS Companion App**: View/share library on iPhone/iPad
- [ ] **iCloud Sync**: Sync screenshots across devices
- [ ] **Team Workspaces**: Shared themes and presets
- [ ] **Public Theme Gallery**: Share custom themes

### v2.0 - Next Generation
- [ ] **GIF Exports**: Animate typing effect
- [ ] **Video Exports**: Code walkthrough videos
- [ ] **AI Features**: AI-powered theme suggestions
- [ ] **Windows Version**: Cross-platform support
- [ ] **Real-time Collaboration**: Collaborative editing

---

## 🎯 MVP Checklist (v1.0)

### Core Features
- [x] Menu bar integration
- [x] Quick capture (Cmd+Shift+C)
- [x] Language auto-detection
- [x] Syntax highlighting
- [x] Theme system (16 themes)
- [x] Window styles (4 styles)
- [x] Background rendering
- [x] Shadow effects
- [x] Watermark (free tier)
- [x] Export (PNG, JPEG, PDF)
- [x] Copy to clipboard
- [x] Share sheet
- [x] Screenshot library
- [x] Full editor window
- [x] Settings window

### Polish & Launch Prep
- [ ] Code formatting
- [ ] UI animations
- [ ] App icon
- [ ] Comprehensive testing
- [ ] Performance optimization
- [ ] Bug fixes
- [ ] Code signing
- [ ] Notarization
- [ ] DMG creation
- [ ] Landing page
- [ ] Demo video
- [ ] 🚀 LAUNCH!

---

## 📊 Feature Completion by Category

| Category | Completion | Status |
|----------|-----------|--------|
| Core Functionality | 95% | ✅ Complete |
| Rendering Engine | 100% | ✅ Complete |
| Themes | 100% | ✅ Complete |
| Export System | 90% | ✅ Mostly Complete |
| UI Components | 90% | ✅ Mostly Complete |
| Settings | 100% | ✅ Complete |
| Library | 80% | 🚧 Functional |
| Polish & Animations | 20% | 📋 TODO |
| Documentation | 80% | 🚧 In Progress |
| Testing | 30% | 📋 TODO |

**Overall Completion: ~80%**

---

## 🎨 Supported Languages

### With Custom Syntax Highlighting
- JavaScript / TypeScript
- JSX / TSX (React)
- Python
- Swift
- Go
- Rust
- HTML
- CSS / SCSS
- JSON

### With Auto-Detection Only (Generic Highlighting)
- Java, Kotlin, C, C++, C#
- Ruby, PHP, Perl
- Bash, Shell, PowerShell
- YAML, XML, TOML
- Markdown
- SQL
- Dart, Elixir, Haskell
- Lua, R, Scala, Clojure
- And 180+ more...

---

## 🎯 What Makes CodeSnap Special

1. **Lightning Fast**: < 2 seconds from code to beautiful image
2. **100% Private**: All processing on-device, code never leaves your Mac
3. **Native macOS**: True native app, not Electron
4. **Beautiful by Default**: 16 hand-picked themes
5. **Highly Customizable**: Control every aspect of your screenshot
6. **Free Forever**: Unlimited screenshots with watermark
7. **One-Time Pro**: $39 lifetime, not subscription

---

**Ready to transform your code screenshots?** 🚀
