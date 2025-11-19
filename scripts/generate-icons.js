// Generate tray and app icons using canvas
const { createCanvas } = require('canvas');
const fs = require('fs');
const path = require('path');

function generateTrayIcon() {
    // Create 32x32 tray icon (will be scaled by OS)
    const canvas = createCanvas(32, 32);
    const ctx = canvas.getContext('2d');

    // Background - rounded square
    ctx.fillStyle = '#007aff';
    roundRect(ctx, 2, 2, 28, 28, 6);
    ctx.fill();

    // Code symbol - < />
    ctx.fillStyle = '#ffffff';
    ctx.font = 'bold 18px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('<>', 16, 16);

    // Save
    const buffer = canvas.toBuffer('image/png');
    fs.writeFileSync(path.join(__dirname, '../assets/tray-icon.png'), buffer);
    console.log('✅ Tray icon generated: assets/tray-icon.png');
}

function generateAppIcon() {
    // Create 512x512 app icon
    const canvas = createCanvas(512, 512);
    const ctx = canvas.getContext('2d');

    // Gradient background
    const gradient = ctx.createLinearGradient(0, 0, 512, 512);
    gradient.addColorStop(0, '#667eea');
    gradient.addColorStop(1, '#764ba2');
    ctx.fillStyle = gradient;
    roundRect(ctx, 0, 0, 512, 512, 80);
    ctx.fill();

    // Inner code window
    ctx.fillStyle = 'rgba(255, 255, 255, 0.95)';
    roundRect(ctx, 60, 100, 392, 312, 16);
    ctx.fill();

    // Window traffic lights
    ctx.fillStyle = '#FF5F57';
    ctx.beginPath();
    ctx.arc(90, 130, 10, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = '#FFBD2E';
    ctx.beginPath();
    ctx.arc(120, 130, 10, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = '#28CA42';
    ctx.beginPath();
    ctx.arc(150, 130, 10, 0, Math.PI * 2);
    ctx.fill();

    // Code lines
    ctx.fillStyle = '#0d1117';
    ctx.font = 'bold 28px monospace';
    ctx.textAlign = 'left';

    const code = [
        'function snap() {',
        '  const code = get();',
        '  return beautiful(code);',
        '}'
    ];

    let y = 190;
    code.forEach(line => {
        ctx.fillText(line, 90, y);
        y += 40;
    });

    // Camera flash effect (bottom right)
    ctx.fillStyle = 'rgba(255, 255, 255, 0.3)';
    ctx.beginPath();
    ctx.arc(420, 380, 40, 0, Math.PI * 2);
    ctx.fill();

    // Save
    const buffer = canvas.toBuffer('image/png');
    fs.writeFileSync(path.join(__dirname, '../assets/icon.png'), buffer);
    console.log('✅ App icon generated: assets/icon.png');
}

function roundRect(ctx, x, y, width, height, radius) {
    ctx.beginPath();
    ctx.moveTo(x + radius, y);
    ctx.lineTo(x + width - radius, y);
    ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
    ctx.lineTo(x + width, y + height - radius);
    ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
    ctx.lineTo(x + radius, y + height);
    ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
    ctx.lineTo(x, y + radius);
    ctx.quadraticCurveTo(x, y, x + radius, y);
    ctx.closePath();
}

// Run
try {
    generateTrayIcon();
    generateAppIcon();
    console.log('\n🎉 All icons generated successfully!');
} catch (error) {
    console.error('❌ Error generating icons:', error);
    process.exit(1);
}
