# 🚀 CodeSnap - Electron Quick Start Guide

Welcome to CodeSnap Electron! This guide will get you up and running in **5 minutes**.

---

## ✅ Step 1: Install Node.js (if not installed)

**Check if you have Node.js:**
```bash
node --version
# Should show v18 or higher
```

**If not installed, download from:**
- **Official Site**: https://nodejs.org
- **Recommended**: LTS version (v20.x)

---

## ✅ Step 2: Install Dependencies

```bash
cd /home/user/cODESNAP

# Install all required packages
npm install
```

This will install:
- Electron
- TypeScript
- highlight.js
- Canvas (for rendering)
- And other dependencies

**Time**: ~2-3 minutes

---

## ✅ Step 3: Build & Run

```bash
# Build TypeScript to JavaScript
npm run build

# Start the app
npm start
```

**That's it!** The app should launch and appear in your system tray.

---

## 🎯 Quick Test

1. **Copy some code** (Cmd/Ctrl+C)
   ```javascript
   function hello() {
     console.log("Hello, CodeSnap!");
   }
   ```

2. **Press the global hotkey**: `Cmd+Shift+C` (Mac) or `Ctrl+Shift+C` (Windows/Linux)

3. **Preview window appears** with your beautiful screenshot!

4. **Click "Copy"** to copy to clipboard

---

## 🔧 Development Mode

For active development with auto-reload:

```bash
npm run dev
```

This runs TypeScript compiler in watch mode + Electron.

---

## 📦 Building for Distribution

### macOS:
```bash
npm run build:mac
```
Output: `release/CodeSnap-1.0.0.dmg`

### Windows:
```bash
npm run build:win
```
Output: `release/CodeSnap Setup 1.0.0.exe`

### Linux:
```bash
npm run build:linux
```
Output: `release/CodeSnap-1.0.0.AppImage`

---

## 🎨 Features to Try

### 1. Quick Capture
- Copy code → Press `Cmd/Ctrl+Shift+C`

### 2. Change Theme
- Right-click tray icon → Settings
- Try: GitHub Dark, Dracula, Nord, Tokyo Night

### 3. Window Styles
- macOS (traffic lights)
- Browser (Chrome-style)
- VS Code (title bar)
- Terminal (command prompt)

### 4. Backgrounds
- Gradient (default: purple to pink)
- Solid color
- Transparent

### 5. Export
- PNG (default)
- JPEG
- PDF

---

## 📁 Where Files Are Stored

### macOS:
```
~/Library/Application Support/CodeSnap/
├── config.json
├── screenshots/
└── metadata/
```

### Windows:
```
%APPDATA%\CodeSnap\
├── config.json
├── screenshots\
└── metadata\
```

### Linux:
```
~/.config/CodeSnap/
├── config.json
├── screenshots/
└── metadata/
```

---

## ⌨️ Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Quick Capture | `Cmd/Ctrl+Shift+C` |
| Open Library | `Cmd/Ctrl+Shift+L` |
| Copy (in preview) | `Cmd/Ctrl+C` |
| Close Window | `Esc` |

---

## 🐛 Troubleshooting

### "npm install" fails

**Error**: Canvas installation fails

**Fix**:
```bash
# macOS
brew install pkg-config cairo pango libpng jpeg giflib librsvg

# Ubuntu/Debian
sudo apt-get install build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev

# Windows
# Install Windows Build Tools
npm install --global windows-build-tools
```

### Hotkey doesn't work

1. Check if another app uses the same shortcut
2. Try restarting the app
3. Change shortcut in Settings

### App crashes on startup

```bash
# Clear cache and rebuild
rm -rf dist node_modules
npm install
npm run build
npm start
```

---

## 🎉 Next Steps

1. **Customize your theme** - Try all 16 themes
2. **Experiment with window styles**
3. **Share your screenshots** on Twitter with #CodeSnap
4. **Give feedback** - Open an issue on GitHub

---

## 🔗 Useful Links

- **Documentation**: See README_ELECTRON.md
- **Themes**: Add custom themes to `themes/` folder
- **Settings**: Edit via UI or directly in config.json

---

## 💡 Pro Tips

**1. Faster workflow:**
```
Copy code → Cmd+Shift+C → Cmd+C → Paste = Done in 3 seconds!
```

**2. Create presets:**
- Set up your favorite theme + window style
- Save as default in Settings

**3. Batch screenshots:**
- Keep app in tray
- Quick capture multiple times
- All saved to library automatically

**4. High quality exports:**
- Use 3x or 4x for print/presentations
- Use 2x (Retina) for web
- Use 1x for quick drafts

---

## ✨ You're Ready!

CodeSnap Electron is now running on your machine.

**Enjoy creating beautiful code screenshots!** 🎨

---

**Questions?** Check README_ELECTRON.md or open an issue on GitHub.
