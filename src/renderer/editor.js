// Editor window logic
let currentScreenshot = {
    code: `function hello() {\n  console.log("Hello, CodeSnap!");\n}`,
    language: 'javascript',
    theme: 'github-dark',
    windowStyle: 'macos',
    backgroundColor: { type: 'gradient', start: '#667eea', end: '#764ba2' },
    fontSize: 14,
    fontFamily: 'JetBrains Mono',
    padding: 48,
    shadow: { enabled: true, size: 40, blur: 60, opacity: 0.3, offsetY: 8 },
    borderRadius: 12,
    showLineNumbers: true,
    exportSize: 2
};

let currentImageDataUrl = null;
let renderTimeout = null;

// Debounced render function
function debounceRender() {
    if (renderTimeout) {
        clearTimeout(renderTimeout);
    }
    renderTimeout = setTimeout(() => {
        renderPreview();
    }, 300);
}

// Tab switching
document.querySelectorAll('.tab').forEach(tab => {
    tab.addEventListener('click', () => {
        const tabName = tab.dataset.tab;

        // Update tabs
        document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
        tab.classList.add('active');

        // Update content
        document.querySelectorAll('.tab-content').forEach(content => {
            content.classList.remove('active');
        });
        document.getElementById(`${tabName}-tab`).classList.add('active');
    });
});

// Initialize code editor
const codeEditor = document.getElementById('codeEditor');
if (codeEditor) {
    codeEditor.value = currentScreenshot.code;
    codeEditor.addEventListener('input', (e) => {
        currentScreenshot.code = e.target.value;
        debounceRender();
    });
}

// Settings listeners with debouncing
document.getElementById('language').addEventListener('change', (e) => {
    currentScreenshot.language = e.target.value;
    renderPreview();
});

document.getElementById('fontFamily').addEventListener('change', (e) => {
    currentScreenshot.fontFamily = e.target.value;
    renderPreview();
});

document.getElementById('fontSize').addEventListener('input', (e) => {
    const value = e.target.value;
    currentScreenshot.fontSize = parseInt(value);
    document.getElementById('fontSizeValue').textContent = value;
    debounceRender();
});

document.getElementById('showLineNumbers').addEventListener('change', (e) => {
    currentScreenshot.showLineNumbers = e.target.checked;
    renderPreview();
});

document.getElementById('padding').addEventListener('input', (e) => {
    const value = e.target.value;
    currentScreenshot.padding = parseInt(value);
    document.getElementById('paddingValue').textContent = value;
    debounceRender();
});

document.getElementById('borderRadius').addEventListener('input', (e) => {
    const value = e.target.value;
    currentScreenshot.borderRadius = parseInt(value);
    document.getElementById('borderRadiusValue').textContent = value;
    debounceRender();
});

document.getElementById('windowStyle').addEventListener('change', (e) => {
    currentScreenshot.windowStyle = e.target.value;
    renderPreview();
});

document.getElementById('enableShadow').addEventListener('change', (e) => {
    currentScreenshot.shadow.enabled = e.target.checked;
    renderPreview();
});

document.getElementById('exportSize').addEventListener('change', (e) => {
    currentScreenshot.exportSize = parseInt(e.target.value);
    // Don't re-render on export size change, just for export
});

// Background buttons
document.querySelectorAll('.bg-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        document.querySelectorAll('.bg-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        const type = btn.dataset.type;
        if (type === 'gradient') {
            currentScreenshot.backgroundColor = { type: 'gradient', start: '#667eea', end: '#764ba2' };
        } else if (type === 'solid') {
            currentScreenshot.backgroundColor = { type: 'solid', color: '#1e1e1e' };
        } else if (type === 'transparent') {
            currentScreenshot.backgroundColor = { type: 'transparent' };
        }

        renderPreview();
    });
});

// Actions
document.getElementById('copyBtn').addEventListener('click', async () => {
    if (currentImageDataUrl) {
        await window.electronAPI.copyToClipboard(currentImageDataUrl);
        showNotification('Copied to clipboard!');
    }
});

document.getElementById('saveBtn').addEventListener('click', async () => {
    if (currentImageDataUrl && currentScreenshot) {
        try {
            await window.electronAPI.saveScreenshot(currentScreenshot, currentImageDataUrl);
            showNotification('Screenshot saved to library!');
        } catch (error) {
            showNotification('Failed to save: ' + error.message);
        }
    } else {
        showNotification('Please render screenshot first');
    }
});

document.getElementById('shareBtn').addEventListener('click', () => {
    // TODO: Implement share
    console.log('Share clicked');
});

// Zoom
let zoomLevel = 1;
document.getElementById('zoomIn').addEventListener('click', () => {
    zoomLevel = Math.min(zoomLevel + 0.25, 3);
    updateZoom();
});

document.getElementById('zoomOut').addEventListener('click', () => {
    zoomLevel = Math.max(zoomLevel - 0.25, 0.5);
    updateZoom();
});

function updateZoom() {
    const img = document.getElementById('previewImage');
    img.style.transform = `scale(${zoomLevel})`;
    document.getElementById('zoomLevel').textContent = `${Math.round(zoomLevel * 100)}%`;
}

// Render preview
async function renderPreview() {
    try {
        const loading = document.querySelector('.loading');
        const img = document.getElementById('previewImage');

        // Validate code
        if (!currentScreenshot.code || currentScreenshot.code.trim().length === 0) {
            loading.textContent = 'Enter some code to render...';
            loading.style.display = 'block';
            img.style.display = 'none';
            return;
        }

        loading.textContent = 'Rendering...';
        loading.style.display = 'block';
        img.style.display = 'none';

        // Call main process to render
        const imageDataUrl = await window.electronAPI.renderScreenshot(currentScreenshot);
        currentImageDataUrl = imageDataUrl;

        loading.style.display = 'none';
        img.src = imageDataUrl;
        img.style.display = 'block';

    } catch (error) {
        const loading = document.querySelector('.loading');
        loading.textContent = `Error: ${error.message}`;
        loading.style.display = 'block';
        loading.style.color = '#ff5f57';
        console.error('Render failed:', error);
        showNotification('Render failed: ' + error.message);
    }
}

function showNotification(message) {
    // Simple notification
    const notification = document.createElement('div');
    notification.className = 'notification';
    notification.textContent = message;
    document.body.appendChild(notification);

    setTimeout(() => {
        notification.remove();
    }, 3000);
}

// Populate themes
async function loadThemes() {
    const themes = [
        { name: 'github-dark', displayName: 'GitHub Dark' },
        { name: 'github-light', displayName: 'GitHub Light' },
        { name: 'dracula', displayName: 'Dracula' },
        { name: 'nord', displayName: 'Nord' },
        { name: 'tokyo-night', displayName: 'Tokyo Night' },
        { name: 'one-dark', displayName: 'One Dark' },
        { name: 'monokai-pro', displayName: 'Monokai Pro' },
        { name: 'catppuccin', displayName: 'Catppuccin' }
    ];

    const grid = document.getElementById('themeGrid');
    themes.forEach(theme => {
        const btn = document.createElement('button');
        btn.className = 'theme-btn';
        if (theme.name === currentScreenshot.theme) {
            btn.classList.add('active');
        }
        btn.textContent = theme.displayName;
        btn.addEventListener('click', () => {
            document.querySelectorAll('.theme-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentScreenshot.theme = theme.name;
            renderPreview();
        });
        grid.appendChild(btn);
    });
}

// Keyboard shortcuts
document.addEventListener('keydown', (e) => {
    // Cmd/Ctrl + S: Save
    if ((e.metaKey || e.ctrlKey) && e.key === 's') {
        e.preventDefault();
        document.getElementById('saveBtn').click();
    }

    // Cmd/Ctrl + C: Copy (when not in textarea)
    if ((e.metaKey || e.ctrlKey) && e.key === 'c' && e.target.tagName !== 'TEXTAREA') {
        e.preventDefault();
        document.getElementById('copyBtn').click();
    }

    // Cmd/Ctrl + R: Re-render
    if ((e.metaKey || e.ctrlKey) && e.key === 'r') {
        e.preventDefault();
        renderPreview();
    }
});

// Initialize
loadThemes();
renderPreview();
