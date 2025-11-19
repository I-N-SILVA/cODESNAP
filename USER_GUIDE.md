# 📸 CodeSnap - Complete User Guide

Welcome to CodeSnap! This guide will walk you through everything you need to know to create beautiful code screenshots.

---

## 🚀 Getting Started

### Step 1: Installation & First Run

```bash
# 1. Install all dependencies
npm install

# 2. Generate app icons (if not auto-generated)
npm run icons

# 3. Build the TypeScript code
npm run build

# 4. Start CodeSnap
npm start
```

**What happens:**
- CodeSnap launches in the background
- A tray icon appears in your system tray/menu bar
- The app is now running and ready to use!

> **Note:** If you don't see a tray icon, that's okay - the app is still running. You can use keyboard shortcuts to access it.

---

## 🎯 Two Ways to Use CodeSnap

### Method 1: Quick Capture (Fastest!)

**Perfect for:** Quick screenshots without customization

**Steps:**

1. **Copy some code** to your clipboard
   ```javascript
   // Example: Copy this code
   function greet(name) {
     console.log(`Hello, ${name}!`);
   }
   ```

2. **Press the keyboard shortcut:**
   - **Mac:** `Cmd + Shift + C`
   - **Windows/Linux:** `Ctrl + Shift + C`

3. **Magic! ✨** A preview window appears instantly with:
   - ✅ Your code beautifully formatted
   - ✅ Syntax highlighting (auto-detected language)
   - ✅ Default theme and styling
   - ✅ Professional look ready to share

4. **What you can do:**
   - **Copy** - Copy the image to clipboard (then paste anywhere!)
   - **Save** - Save to your library
   - **Edit More...** - Open full editor for customization
   - **Close** - Click the × or wait 30 seconds (auto-closes)

**Pro Tip:** The preview window is draggable! Click and drag the header to move it around.

---

### Method 2: Full Editor (Maximum Control!)

**Perfect for:** Custom styling, multiple edits, experimenting with themes

**Steps:**

#### Opening the Editor

**Option A:** Click the tray icon → "Open Library"

**Option B:** Use keyboard shortcut:
- **Mac:** `Cmd + Shift + L`
- **Windows/Linux:** `Ctrl + Shift + L`

**Option C:** From Quick Preview → Click "Edit More..."

---

## 🎨 Using the Full Editor

The editor has **4 tabs** for different customization options:

### Tab 1: CODE 📝

This is where you write or paste your code.

**Steps:**

1. **Paste or type your code** in the large text area
   ```python
   # Example Python code
   def calculate_fibonacci(n):
       if n <= 1:
           return n
       return calculate_fibonacci(n-1) + calculate_fibonacci(n-2)
   ```

2. **Select the language** (or leave on "Auto-detect")
   - Auto-detect works great for most languages
   - Manual selection: JavaScript, TypeScript, Python, Swift, Go, Rust, HTML, CSS, JSON

3. **Choose font family**
   - JetBrains Mono (recommended)
   - Fira Code
   - Monaco
   - Menlo

4. **Adjust font size** (12px - 24px)
   - Drag the slider
   - Watch the preview update in real-time (debounced)

5. **Toggle line numbers** on/off

**The preview updates automatically as you type!** (with a 300ms delay for smooth performance)

---

### Tab 2: STYLE 🎨

Customize colors and spacing.

**Steps:**

1. **Choose a theme** (16 beautiful options!)

   **Dark Themes:**
   - GitHub Dark (default)
   - Dracula
   - Nord
   - Tokyo Night
   - One Dark
   - Monokai Pro
   - Catppuccin
   - Synthwave '84
   - Material Dark
   - Gruvbox

   **Light Themes:**
   - GitHub Light
   - One Light
   - Solarized Light
   - Rosé Pine Dawn
   - Ayu Light
   - Nord Light

   **How:** Click any theme button - preview updates instantly!

2. **Adjust padding** (16px - 80px)
   - More padding = more space around code
   - Less padding = tighter, compact look
   - Recommended: 48px

3. **Adjust border radius** (0px - 24px)
   - 0px = sharp corners
   - 12px = slightly rounded (recommended)
   - 24px = very rounded

---

### Tab 3: WINDOW 🪟

Customize the window frame and background.

**Steps:**

1. **Select window style:**
   - **None** - Just the code, no chrome
   - **macOS** - Mac-style with traffic lights (red, yellow, green)
   - **Browser** - Browser-style chrome
   - **VS Code** - VS Code-style
   - **Terminal** - Terminal-style

2. **Choose background type:**

   **Gradient** (default):
   - Beautiful purple gradient
   - Makes your screenshot pop!

   **Solid**:
   - Solid dark color
   - Professional and clean

   **Transparent**:
   - No background
   - Perfect for overlaying on other images

3. **Enable/disable shadow**
   - ✅ Enabled: Adds depth and dimension
   - ❌ Disabled: Flat look

---

### Tab 4: EXPORT 💾

Save or copy your screenshot.

**Steps:**

1. **Select export size:**
   - **1x** - Normal resolution
   - **2x** - Retina/High-DPI (recommended)
   - **3x** - Extra high quality
   - **4x** - Maximum quality

2. **Export options:**

   **📋 Copy to Clipboard** (or press `Cmd/Ctrl+C`)
   - Copies image to clipboard
   - Paste directly into Slack, Discord, Twitter, etc.
   - Notification confirms: "Copied to clipboard!"

   **💾 Save to File** (or press `Cmd/Ctrl+S`)
   - Saves to your CodeSnap library
   - Stored in: `~/Library/Application Support/codesnap/screenshots/`
   - Includes metadata for later editing

   **↗️ Share** (coming soon!)
   - Will open OS share dialog
   - Share to social media, email, etc.

---

## ⌨️ Keyboard Shortcuts

Speed up your workflow with these shortcuts:

### Global Shortcuts (work anywhere)
| Shortcut | Action |
|----------|--------|
| `Cmd/Ctrl + Shift + C` | Quick Capture |
| `Cmd/Ctrl + Shift + L` | Open Library |

### Editor Shortcuts (when editor is open)
| Shortcut | Action |
|----------|--------|
| `Cmd/Ctrl + S` | Save screenshot |
| `Cmd/Ctrl + C` | Copy to clipboard |
| `Cmd/Ctrl + R` | Re-render preview |

### Navigation
| Action | How |
|--------|-----|
| Switch tabs | Click tab buttons |
| Move preview window | Drag the header |
| Close preview | Click × or press Escape |

---

## 💡 Pro Tips & Best Practices

### 1. **Quick Workflow for Social Media**

```
1. Copy code → Cmd+Shift+C
2. Preview appears
3. Click "Copy"
4. Paste directly into Twitter/LinkedIn
✅ Done in 3 seconds!
```

### 2. **Customizing Defaults**

Edit these in the code editor:
- Start with your favorite theme
- Adjust padding to your liking
- Set your preferred font

### 3. **Best Themes for Different Contexts**

- **Tutorials/Blogs:** GitHub Light or One Light (easy to read)
- **Social Media:** Tokyo Night, Dracula, or Synthwave '84 (eye-catching)
- **Documentation:** GitHub Dark or Nord (professional)
- **Presentations:** Monokai Pro or Catppuccin (high contrast)

### 4. **Code Selection Tips**

**Good code for screenshots:**
- ✅ Short (5-20 lines)
- ✅ Complete (shows full function/class)
- ✅ Formatted (proper indentation)
- ✅ Meaningful (demonstrates a concept)

**Avoid:**
- ❌ Very long files (hard to read)
- ❌ Overly complex code (confusing)
- ❌ Code with sensitive info (API keys, passwords)

### 5. **Performance Tips**

- The editor debounces rendering (300ms delay)
- Don't worry about typing fast - it won't lag!
- Sliders update smoothly thanks to debouncing

---

## 📁 Where Are My Screenshots Saved?

### Library Location

**macOS:**
```
~/Library/Application Support/codesnap/screenshots/
```

**Windows:**
```
%APPDATA%/codesnap/screenshots/
```

**Linux:**
```
~/.config/codesnap/screenshots/
```

### File Structure

```
codesnap/
├── screenshots/
│   ├── 1234567890.png
│   ├── 1234567891.png
│   └── ...
└── metadata/
    ├── 1234567890.json
    ├── 1234567891.json
    └── ...
```

Each screenshot has:
- **PNG file** - The rendered image
- **JSON file** - Metadata (code, theme, settings)

---

## 🎬 Complete Example Workflows

### Example 1: Share on Twitter

**Scenario:** You just wrote a cool function and want to share it.

```
1. Select your function in your editor
2. Copy (Cmd+C)
3. Press Cmd+Shift+C (Quick Capture)
4. Preview appears
5. Click "Copy"
6. Go to Twitter
7. Paste (Cmd+V)
8. Add your tweet text
9. Post! 🚀
```

**Time:** ~10 seconds

---

### Example 2: Create Tutorial Screenshot

**Scenario:** You're writing a blog post and need a custom screenshot.

```
1. Click tray icon → Open Library (or Cmd+Shift+L)
2. Editor opens
3. Paste your code in the textarea
4. Choose theme: "GitHub Light" (readable for tutorials)
5. Adjust padding: 60px (more whitespace)
6. Enable line numbers
7. Preview updates automatically
8. Looks good? Press Cmd+S
9. Screenshot saved to library!
```

**Time:** ~30 seconds

---

### Example 3: Create Multiple Variations

**Scenario:** You want to A/B test different themes.

```
1. Open editor (Cmd+Shift+L)
2. Paste code once
3. Click "Dracula" theme → Cmd+S (saves)
4. Click "Nord" theme → Cmd+S (saves)
5. Click "Tokyo Night" → Cmd+S (saves)
6. Now you have 3 versions to choose from!
```

**Time:** ~20 seconds for 3 variations

---

## 🐛 Troubleshooting

### App doesn't start

**Check:**
```bash
# Did dependencies install?
npm install

# Did TypeScript compile?
npm run build

# Try running with logs
npm start
```

### No tray icon visible

**Solutions:**
- App still works! Use keyboard shortcuts
- Check system tray settings
- Try restarting the app

### Preview window doesn't appear

**Check:**
1. Did you copy code to clipboard first?
2. Is there actually text in clipboard?
3. Check console for errors: `npm start` and watch output

### Rendering looks wrong

**Try:**
1. Refresh the preview (Cmd+R)
2. Check font is available on your system
3. Try a different theme
4. Restart the app

### Code not highlighting

**Fixed in latest version!** Make sure you have the latest code:
```bash
git pull origin main
npm run build
npm start
```

---

## 🎓 Understanding the Interface

### Quick Preview Window

```
┌─────────────────────────────────┐
│ JAVASCRIPT        Copy      ×   │  ← Header (drag to move)
├─────────────────────────────────┤
│                                 │
│     [Your code screenshot]      │  ← Live preview
│                                 │
├─────────────────────────────────┤
│  Save  │  Share  │ Edit More... │  ← Actions
└─────────────────────────────────┘
```

### Full Editor Layout

```
┌──────────┬────────────────────────┐
│ Code     │   LIVE PREVIEW         │
│ Style    │                        │
│ Window   │   [Your code]          │
│ Export   │                        │
│          │                        │
│ [Settings│   Updates as you       │
│  for     │   customize!           │
│  active  │                        │
│  tab]    │                        │
│          │   Zoom: - 100% +       │
└──────────┴────────────────────────┘
  Sidebar      Preview Panel
```

---

## 🔮 Advanced Features

### Zoom Controls

In the editor preview:
- Click **"+"** to zoom in (up to 300%)
- Click **"-"** to zoom out (down to 50%)
- Check details at high zoom

### Auto-Save to Library

When enabled (default):
- Every Quick Capture automatically saves
- Find them in your library folder
- Includes all metadata for re-editing

### Watermark

Watermark is enabled by default:
- Shows "Created with CodeSnap"
- Positioned at bottom-right
- Subtle and professional

---

## 🎯 Common Use Cases

### 1. **Social Media Posts**
- Quick Capture
- Copy to clipboard
- Paste into tweet/post

### 2. **Blog Post Images**
- Open editor
- Customize extensively
- Save high-res (2x or 3x)
- Insert into blog

### 3. **Documentation**
- Use light themes
- Enable line numbers
- Consistent styling across docs

### 4. **Code Reviews**
- Capture problematic code
- Add to review comments
- Visual context for feedback

### 5. **Teaching/Tutorials**
- Step-by-step code progression
- Different themes for different concepts
- Clear, readable screenshots

---

## 📊 Language Support

CodeSnap supports syntax highlighting for:

### Fully Supported (custom highlighting):
- JavaScript / JSX
- TypeScript / TSX
- Python
- Swift
- Go
- Rust
- HTML
- CSS / SCSS
- JSON

### Auto-Detected (via highlight.js):
- Java, C, C++, C#
- Ruby, PHP
- Shell/Bash
- SQL
- Markdown
- YAML
- And 200+ more!

**Auto-detect is smart!** It analyzes your code and picks the right language automatically.

---

## 🆘 Getting Help

### Resources
- **Full Audit Report:** See `AUDIT_REPORT.md` for technical details
- **Changelog:** See `CHANGELOG.md` for what's new
- **Electron Docs:** See `README_ELECTRON.md`

### Common Questions

**Q: Can I edit a saved screenshot?**
A: Not yet, but coming soon! For now, use the same code + settings.

**Q: Can I change the watermark text?**
A: Yes, but requires code edit. Settings window coming soon.

**Q: Does it work offline?**
A: Yes! 100% offline, no internet required.

**Q: Can I use custom fonts?**
A: Currently supports system fonts. Custom font support coming.

**Q: How do I share with my team?**
A: Copy to clipboard, paste in Slack/Teams. Or save files and share via Google Drive/Dropbox.

---

## 🎉 You're Ready!

You now know everything you need to create beautiful code screenshots with CodeSnap!

### Quick Recap

1. **Quick screenshots:** Copy code → `Cmd+Shift+C` → Done!
2. **Custom screenshots:** Open editor → Customize → Save
3. **Share:** Copy to clipboard → Paste anywhere
4. **Keyboard shortcuts:** Speed up your workflow

### Next Steps

1. Try a quick capture right now!
2. Experiment with different themes
3. Find your favorite settings
4. Start sharing beautiful code! 🚀

---

## 💝 Enjoy CodeSnap!

Create beautiful code screenshots in seconds. Share your knowledge. Make your code look amazing.

Happy screenshotting! 📸✨

---

**Version:** 1.1.0
**Last Updated:** 2025-11-19
**Questions?** Check the audit report or changelog for technical details.
