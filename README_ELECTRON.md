# CodeSnap - Electron Version

**Beautiful code screenshots - Now cross-platform!**

This is the Electron version of CodeSnap, which works on **macOS, Windows, and Linux** without needing Xcode.

---

## 🚀 Quick Start

### Prerequisites
- **Node.js 18+** (Download from [nodejs.org](https://nodejs.org))
- **npm** or **yarn**

### Installation

```bash
# 1. Install dependencies
npm install

# 2. Build TypeScript
npm run build

# 3. Start the app
npm start
```

That's it! The app will launch and appear in your system tray.

---

## 📦 Project Structure

```
cODESNAP/
├── src/
│   ├── main/                  # Main process (Node.js)
│   │   ├── index.ts          # App entry point
│   │   ├── preload.ts        # Preload script (bridge)
│   │   └── services/         # Business logic
│   │       ├── RenderService.ts
│   │       ├── StorageService.ts
│   │       └── ScreenshotService.ts
│   │
│   └── renderer/             # Renderer process (Browser)
│       ├── preview.html      # Quick preview window
│       ├── editor.html       # Full editor
│       ├── editor.js         # Editor logic
│       └── styles/           # CSS styles
│
├── themes/                   # Theme JSON files (copied from Resources)
├── dist/                     # Compiled TypeScript
├── release/                  # Built packages
├── package.json
└── tsconfig.json
```

---

## 🎯 Features

All features from the Swift version, now cross-platform:

✅ **Quick Capture** (Ctrl/Cmd+Shift+C)
✅ **Auto Language Detection** (30+ languages)
✅ **Syntax Highlighting** (highlight.js)
✅ **16 Beautiful Themes**
✅ **4 Window Styles** (macOS, Browser, VS Code, Terminal)
✅ **Backgrounds** (Solid, Gradient, Transparent)
✅ **Shadows & Effects**
✅ **Export** (PNG, JPEG, PDF)
✅ **System Tray** Integration
✅ **Settings** Persistence

---

## 🛠️ Development

### Run in Development Mode

```bash
# Watch TypeScript and auto-reload
npm run dev
```

### Build for Production

```bash
# Build TypeScript
npm run build

# Package for current platform
npm run package

# Build for macOS
npm run build:mac

# Build for Windows
npm run build:win

# Build for Linux
npm run build:linux
```

---

## 📋 Differences from Swift Version

### What's the Same:
- All core features
- Same UI/UX
- Same themes
- Same settings
- Same hotkeys

### What's Different:

| Feature | Swift Version | Electron Version |
|---------|--------------|------------------|
| Platform | macOS only | macOS, Windows, Linux |
| Size | ~20 MB | ~150 MB (includes Chromium) |
| Performance | Native (fast) | Good (JavaScript) |
| Memory | ~50 MB | ~100-150 MB |
| Startup | < 1 second | ~2 seconds |
| Updates | Manual | Auto-update ready |

---

## 🎨 How It Works

### Rendering Pipeline

1. **User captures code** (Ctrl/Cmd+Shift+C)
2. **Main process** gets clipboard content
3. **RenderService** creates canvas:
   - Highlights code with highlight.js
   - Draws background (gradient/solid/transparent)
   - Adds window chrome (macOS/browser/etc)
   - Applies shadows
   - Adds watermark (free tier)
4. **Canvas → PNG** data URL
5. **Preview window** shows result
6. **User actions**: Copy/Save/Share

### Technology Stack

**Main Process:**
- Electron (native APIs)
- Node.js Canvas (image rendering)
- highlight.js (syntax highlighting)
- electron-store (settings)

**Renderer Process:**
- HTML/CSS/JavaScript
- No framework (vanilla JS for speed)
- System fonts

---

## 🔧 Configuration

### Settings Location

- **macOS**: `~/Library/Application Support/CodeSnap/`
- **Windows**: `%APPDATA%/CodeSnap/`
- **Linux**: `~/.config/CodeSnap/`

### Files Stored

```
CodeSnap/
├── config.json           # App settings
├── screenshots/          # Saved screenshots
│   ├── 123456.png
│   └── 123457.png
└── metadata/            # Screenshot metadata
    ├── 123456.json
    └── 123457.json
```

---

## 🚀 Building & Distribution

### Code Signing (macOS)

```bash
# Set up environment variables
export CSC_LINK=/path/to/certificate.p12
export CSC_KEY_PASSWORD=your_password

# Build signed app
npm run build:mac
```

### Auto-Update Setup

1. Upload releases to GitHub
2. electron-updater will check for updates
3. Users get notified automatically

---

## 🎯 Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Quick Capture | Ctrl/Cmd+Shift+C |
| Open Library | Ctrl/Cmd+Shift+L |
| Copy to Clipboard | Ctrl/Cmd+C (in preview) |
| Save to File | Ctrl/Cmd+S (in preview) |
| Close Window | Esc |

---

## 🐛 Troubleshooting

### App Won't Start

```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
npm run build
npm start
```

### Hotkeys Don't Work

1. Check if another app uses the same hotkey
2. Try changing the hotkey in Settings
3. Restart the app

### Can't Save Screenshots

1. Check file permissions
2. Verify save location exists
3. Check disk space

---

## 📊 Performance Tips

**Optimize Rendering:**
- Use smaller export sizes (1x-2x) for drafts
- Disable shadows for faster rendering
- Limit code to < 500 lines

**Reduce Memory:**
- Close unused windows
- Clear old screenshots from library
- Restart app if it uses > 500 MB

---

## 🔜 Roadmap

**v1.1:**
- [ ] Code formatting (Prettier)
- [ ] More syntax highlighters
- [ ] Custom theme creator
- [ ] Line highlighting

**v1.2:**
- [ ] Annotations (arrows, boxes)
- [ ] Multi-file screenshots
- [ ] GIF export
- [ ] Cloud sync

---

## 🆚 Why Electron?

### Pros:
✅ Cross-platform (Windows, Linux, macOS)
✅ No Xcode needed
✅ Easier to develop
✅ Auto-updates built-in
✅ Larger ecosystem (npm packages)

### Cons:
❌ Larger app size (~150 MB vs ~20 MB)
❌ More memory usage
❌ Slower startup
❌ Not as "native" feeling

---

## 📝 Development Notes

### Adding a New Theme

1. Create `themes/my-theme.json`:
```json
{
  "name": "my-theme",
  "displayName": "My Theme",
  "isDark": true,
  "colors": {
    "background": "#1e1e1e",
    "foreground": "#ffffff",
    ...
  }
}
```

2. Themes are auto-loaded on app start

### Adding a New Window Style

Edit `src/main/services/RenderService.ts`:
```typescript
private renderWindowChrome(ctx, x, y, width, height, style, isDark) {
    if (style === 'my-style') {
        // Your custom chrome here
    }
}
```

---

## 🎉 Success!

You now have a fully functional, cross-platform code screenshot app!

**Next Steps:**
1. Customize themes
2. Try all window styles
3. Share your screenshots
4. Give feedback!

**Built with ❤️ using Electron**
