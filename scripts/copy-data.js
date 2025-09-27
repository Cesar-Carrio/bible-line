#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

/**
 * Recursively copy a directory from source to destination
 * @param {string} src - Source directory path
 * @param {string} dest - Destination directory path
 */
function copyDirectory(src, dest) {
  try {
    // Create destination directory if it doesn't exist
    if (!fs.existsSync(dest)) {
      fs.mkdirSync(dest, { recursive: true });
    }

    // Read the source directory
    const items = fs.readdirSync(src);

    for (const item of items) {
      const srcPath = path.join(src, item);
      const destPath = path.join(dest, item);

      const stat = fs.statSync(srcPath);

      if (stat.isDirectory()) {
        // Recursively copy subdirectories
        copyDirectory(srcPath, destPath);
      } else {
        // Copy files
        fs.copyFileSync(srcPath, destPath);
        console.log(`Copied: ${srcPath} -> ${destPath}`);
      }
    }
  } catch (error) {
    console.error(`Error copying directory: ${error.message}`);
    process.exit(1);
  }
}

// Main execution
const srcDir = path.join(__dirname, '..', 'src', 'data');
const destDir = path.join(__dirname, '..', 'dist', 'data');

console.log('Copying data directory...');
console.log(`Source: ${srcDir}`);
console.log(`Destination: ${destDir}`);

copyDirectory(srcDir, destDir);
console.log('Data directory copied successfully!');
