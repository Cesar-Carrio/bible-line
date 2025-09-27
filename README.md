# Bible Line 📖

A beautiful terminal application that fetches and displays random Bible chapters with an interactive scrollable interface and colorful formatting.

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Installation Options](#installation-options)
- [Usage](#usage)
- [Auto-Run on Terminal Startup](#auto-run-on-terminal-startup)
- [Development](#development)
- [API Source](#api-source)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Roadmap](#roadmap)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Features

- 🎲 Displays random Bible chapters
- 📜 **Interactive scrollable interface** with keyboard navigation (default)
- 🌈 Colorful terminal output with verse numbers
- ⌨️ **Keyboard controls**: Arrow keys, vim keys (j/k), mouse wheel scrolling
- 🖥️ **Dual display modes**: Scrollable interface or traditional console output
- 📱 Cross-platform compatibility (Windows, macOS, Linux)
- 🚀 Fast and lightweight
- 💻 Works in all shells (Bash, Zsh, PowerShell, etc.)
- 🛡️ Robust error handling
- 📖 King James Version (KJV) Bible text
- 🎯 **Visual scrollbar** and intuitive navigation
- 🚪 **Easy exit**: Press `q`, `Esc`, or `Ctrl+C` to exit

## Quick Start

### Prerequisites

- [Node.js](https://nodejs.org/) (version 14 or higher)
- npm (comes with Node.js)

### 🚀 Easy Installation (Recommended)

```bash
# 1. Clone the repository
git clone https://github.com/cesar-carrio/bible-line.git
cd bible-line

# 2. Install and build
npm install
npm run build

# 3. Test the app
npm start
# OR install globally: npm link && bible-line

# 4. Set up auto-run (optional)
./setup-autorun.sh        # Unix/Linux/macOS
# or
.\setup-autorun.ps1       # Windows PowerShell
```

**That's it! 🎉** Open a new terminal to see Bible verses automatically, or run `bible-line` from anywhere.

---

## Installation Options

### Option 1: Local Development Setup

```bash
git clone https://github.com/cesar-carrio/bible-line.git
cd bible-line
npm install
npm run build
npm start
```

### Option 2: Global Executable

```bash
# After cloning and building
npm link

# Now run from anywhere
bible-line
```

### Option 3: Direct Node Execution

```bash
# After building
node dist/index.js
```

### Option 4: From npm (Future)

```bash
# Available once published
npm install -g bible-line
bible-line
```

## Usage

### Basic Usage

```bash
# If installed as global executable
bible-line

# Or from project directory
npm start
```

### Command Line Options

```bash
# Default: Interactive scrollable interface (if installed globally)
bible-line

# Traditional console output
bible-line --console
bible-line -c

# Show help information
bible-line --help
bible-line -h

# Show version information
bible-line --version
bible-line -v

# Or from project directory
npm start                    # Scrollable interface (default)
npm start -- --console       # Traditional console output
npm start -- --help
npm start -- --version
```

### Display Modes

**🔄 Scrollable Interface (Default):**
- Interactive navigation with arrow keys or vim keys (j/k)
- Visual scrollbar showing position in the text
- Mouse wheel support
- Press `q`, `Esc`, or `Ctrl+C` to exit
- Perfect for longer chapters that exceed terminal height

**📄 Traditional Console Output:**
- Classic terminal output with colored text
- All verses printed at once
- Use `--console` or `-c` flag to enable
- Ideal for scripting or piping output

### Example Output

**Scrollable Interface (Default):**
```
┌─────────────────────────────────────────────────────────────────┐
│ Book: psalms - Chapter: 23                                      │
│                                                                 │
│ 1  The LORD is my shepherd; I shall not want.                  │
│ 2  He maketh me to lie down in green pastures: he leadeth me   │
│    beside the still waters.                                    │
│ 3  He restoreth my soul: he leadeth me in the paths of        │
│    righteousness for his name's sake.                         │
│ 4  Yea, though I walk through the valley of the shadow of     │
│    death, I will fear no evil: for thou art with me; thy rod  │
│    and thy staff they comfort me.                             │
│ 5  Thou preparest a table before me in the presence of mine   │
│    enemies: thou anointest my head with oil; my cup runneth   │
│    over.                                                       │
│ 6  Surely goodness and mercy shall follow me all the days of  │
│    my life: and I will dwell in the house of the LORD for     │
│    ever.                                                       │
│                                                                │
│ Total verses: 6                                                │
└─────────────────────────────────────────────────────────────────┘
    Use ↑↓ arrows or j/k to scroll • Press q or Ctrl+C to exit
```

**Traditional Console Output (`--console`):**
```
Fetching Bible chapter...

Book: psalms - Chapter: 23

1  The LORD is my shepherd; I shall not want.
2  He maketh me to lie down in green pastures: he leadeth me beside the still waters.
3  He restoreth my soul: he leadeth me in the paths of righteousness for his name's sake.
4  Yea, though I walk through the valley of the shadow of death, I will fear no evil: for thou art with me; thy rod and thy staff they comfort me.
5  Thou preparest a table before me in the presence of mine enemies: thou anointest my head with oil; my cup runneth over.
6  Surely goodness and mercy shall follow me all the days of my life: and I will dwell in the house of the LORD for ever.

Total verses: 6
```

## Development

### Project Structure

```
bible-line/
├── src/
│   ├── data/
│   │   └── bibleChapters.json    # Bible book and chapter data
│   └── index.ts                  # Main application code with scrollable UI
├── dist/                         # Compiled JavaScript output
├── setup-autorun.sh              # Unix/Linux/macOS setup script
├── setup-autorun.ps1             # Windows PowerShell setup script
├── uninstall-autorun.sh          # Unix/Linux/macOS uninstall script
├── uninstall-autorun.ps1         # Windows PowerShell uninstall script
├── uninstall-autorun.bat         # Windows batch file uninstall script
├── package.json                  # npm configuration with bin field
├── tsconfig.json                 # TypeScript configuration
└── README.md                     # This file
```

### Development Workflow

```bash
# Install dependencies
npm install

# Build TypeScript to JavaScript
npm run build

# Test the application
npm start

# Install as global executable for testing
npm link
bible-line

# Development mode with auto-rebuild
npm run dev
```

### Making Changes

1. **Edit source files** in the `src/` directory
2. **Build changes**: `npm run build`
3. **Test locally**: `npm start` or `bible-line` (if linked)
4. **Test setup scripts**: `./setup-autorun.sh --help`

### Key Files

- **`src/index.ts`**: Main application logic with CLI interface
- **`package.json`**: Contains `bin` field for executable functionality
- **`setup-autorun.sh`**: Automated setup for Unix-like systems
- **`setup-autorun.ps1`**: Automated setup for Windows PowerShell

## API Source

This application uses the [Bible API](https://github.com/wldeh/bible-api) hosted on jsDelivr CDN to fetch Bible verses. The API provides:

- King James Version (KJV) text
- JSON format responses
- Reliable CDN delivery
- No authentication required

## Auto-Run on Terminal Startup

You can configure Bible Line to automatically display a random Bible chapter every time you open a new terminal window or session.

### 🚀 Automated Setup Scripts (Recommended)

We've created automated setup scripts that handle everything for you:

#### For Unix/Linux/macOS (Bash, Zsh, Fish):
```bash
./setup-autorun.sh
```

#### For Windows (PowerShell):
```powershell
.\setup-autorun.ps1
```

#### What the setup scripts do:
- 🔍 **Detect your shell** automatically (zsh, bash, fish, PowerShell)
- 🔗 **Install bible-line** as a global executable (using `npm link`)
- 💾 **Create backups** of your existing configuration files
- ⚙️ **Add Bible Line** to your shell's startup configuration
- ✅ **Show preview** of exactly what will be added before making changes
- 🛡️ **Handle errors** gracefully without crashing your terminal
- 🚫 **Prevent recursion** with built-in safety checks

#### Script Features:
- **Cross-platform timeout** handling (Linux `timeout` vs macOS `gtimeout`)
- **Permission handling** (tries without sudo first, then with sudo if needed)
- **Graceful fallbacks** (falls back to project directory if npm link fails)
- **Safe execution** (won't crash your terminal like the old version)
- **Easy removal** with companion `uninstall-autorun.sh` script

### 📋 Manual Setup

If you prefer to configure manually or the automated script doesn't work for your setup:

### For Zsh (macOS default, Linux)

Add to your `~/.zshrc` file:

```bash
# Open your .zshrc file
nano ~/.zshrc

# Add this line at the end of the file
cd /path/to/bible-line && npm start --silent

# Or if you prefer a more robust approach:
(cd /path/to/bible-line && npm start --silent 2>/dev/null) || echo "Bible Line not available"
```

### For Bash (Linux, macOS, Windows WSL)

Add to your `~/.bashrc` or `~/.bash_profile` file:

```bash
# Open your bash configuration file
nano ~/.bashrc   # Linux
nano ~/.bash_profile   # macOS

# Add this line at the end of the file
cd /path/to/bible-line && npm start --silent

# Or the robust version:
(cd /path/to/bible-line && npm start --silent 2>/dev/null) || echo "Bible Line not available"
```

### For Fish Shell

Add to your `~/.config/fish/config.fish` file:

```fish
# Open your Fish config file
nano ~/.config/fish/config.fish

# Add this line at the end of the file
cd /path/to/bible-line; and npm start --silent

# Or the robust version:
cd /path/to/bible-line; and npm start --silent 2>/dev/null; or echo "Bible Line not available"
```

### For PowerShell (Windows)

Add to your PowerShell profile:

```powershell
# Find your profile location
echo $PROFILE

# Edit your profile (create if it doesn't exist)
notepad $PROFILE

# Add this line:
Set-Location "C:\path\to\bible-line"; npm start --silent

# Or the robust version:
try { Set-Location "C:\path\to\bible-line"; npm start --silent } catch { Write-Host "Bible Line not available" }
```

### Step-by-Step Setup Guide

1. **Find your project path:**
   ```bash
   # In your bible-line directory, run:
   pwd
   # Copy this path for the next steps
   ```

2. **Choose your shell configuration file:**
   - **Zsh**: `~/.zshrc`
   - **Bash**: `~/.bashrc` (Linux) or `~/.bash_profile` (macOS)
   - **Fish**: `~/.config/fish/config.fish`
   - **PowerShell**: Use `echo $PROFILE` to find location

3. **Add the command:**
   ```bash
   # Replace /path/to/bible-line with your actual path
   echo 'cd /path/to/bible-line && npm start --silent' >> ~/.zshrc
   ```

4. **Reload your configuration:**
   ```bash
   # For Zsh
   source ~/.zshrc
   
   # For Bash
   source ~/.bashrc   # or ~/.bash_profile
   
   # For Fish
   source ~/.config/fish/config.fish
   
   # For PowerShell, restart PowerShell or run:
   . $PROFILE
   ```

### Advanced Configuration Options

**Conditional Loading (Recommended):**
```bash
# Only run if the directory exists and we're in an interactive shell
if [[ -d "/path/to/bible-line" && $- == *i* ]]; then
    (cd /path/to/bible-line && npm start --silent 2>/dev/null)
fi
```

**Run with Delay:**
```bash
# Add a small delay to let terminal fully load
(sleep 1 && cd /path/to/bible-line && npm start --silent 2>/dev/null) &
```

**Skip on Specific Conditions:**
```bash
# Skip if we're in a git repository (to avoid interrupting development)
if [[ -d "/path/to/bible-line" && ! -d ".git" && $- == *i* ]]; then
    (cd /path/to/bible-line && npm start --silent 2>/dev/null)
fi
```

### Notes and Tips

- **Use `--silent` flag** to suppress npm output and only show the Bible verse
- **Use full absolute paths** to avoid issues when starting terminal from different directories
- **Test first** by running the command manually before adding to your RC file
- **Consider performance** - this adds a small delay to terminal startup
- **Make it conditional** to avoid errors if the project is moved or deleted
- **Use `2>/dev/null`** to suppress error messages if the app fails to run

### Removing Auto-Run

#### 🚀 Easy Removal (Recommended)
Use the automated uninstall scripts for your platform:

**Unix/Linux/macOS:**
```bash
./uninstall-autorun.sh
```

**Windows PowerShell:**
```powershell
.\uninstall-autorun.ps1
```

**Windows Command Prompt:**
```cmd
uninstall-autorun.bat
```

#### What the uninstall scripts do:
- 🔍 **Detect configurations** in all shell profiles automatically
- 💾 **Create backups** before making any changes
- 🗑️ **Remove Bible Line** from all detected shell configurations
- ✅ **Clean removal** of both scrollable and console output modes
- 🔧 **Optional global executable removal** via npm unlink/uninstall
- 📋 **Show manual usage** instructions after removal

#### Manual Removal
To stop Bible Line from running automatically:

1. Open your shell configuration file
2. Remove or comment out the Bible Line section
3. Reload your configuration or restart your terminal

```bash
# Comment out the lines by adding # at the beginning
# # Bible Line - Random Bible verse on terminal startup
# # Bible Line execution with safeguards
# if [[ -z "$BIBLE_LINE_RUNNING" && $- == *i* ]]; then
#     export BIBLE_LINE_RUNNING=1
#     timeout 10s bible-line 2>/dev/null || true
#     unset BIBLE_LINE_RUNNING
# fi
```

## Troubleshooting

### Common Issues

**Setup Script Issues:**
- **"Error: This script should be executed, not sourced"**
  - Use `./setup-autorun.sh` instead of `. ./setup-autorun.sh`
  - The script must be executed, not sourced, for safety
  
- **npm link permission errors**
  - The script will automatically try with sudo if needed
  - Or run manually: `sudo npm link`

**Application Issues:**
- **"No Bible books found in data"**
  - Ensure `src/data/bibleChapters.json` exists and contains valid JSON
  - Try rebuilding: `npm run build`

- **Network Errors**
  - Check internet connection (required for fetching Bible text)
  - Try running the command again

- **"bible-line command not found"**
  - Run `npm link` to create global executable
  - Or use `npm start` from the project directory

**Permission Issues (macOS/Linux):**
- Make scripts executable: `chmod +x setup-autorun.sh`
- For npm link issues: `sudo npm link`

**Node.js Issues:**
- Install Node.js from [nodejs.org](https://nodejs.org/)
- Verify installation: `node --version`

### Shell Compatibility

This app is tested and works with:
- ✅ Bash (Linux, macOS, Windows WSL)
- ✅ Zsh (macOS default)
- ✅ Fish shell
- ✅ PowerShell (Windows)
- ✅ Command Prompt (Windows)

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Build and test: `npm run build && npm start`
5. Commit your changes: `git commit -am 'Add some feature'`
6. Push to the branch: `git push origin feature-name`
7. Submit a pull request

## Roadmap

We have exciting plans for Bible Line! Check out our [ROADMAP.md](ROADMAP.md) to see what's coming next:

🚀 **Phase 1 (High Priority)**:
- GitHub Actions for CI/CD
- Publish to npm registry  
- Add project badges
- Create GitHub releases

📈 **Future Phases**:
- Multiple Bible versions support
- Interactive mode with search
- Desktop integration
- Mobile companion app

Want to contribute to any of these features? See our [Contributing Guide](CONTRIBUTING.md) and pick up any roadmap item!

## License

This project is open source. Please check the LICENSE file for details.

## Scripts Reference

### Setup Scripts

- **`setup-autorun.sh`**: Automated setup for Unix/Linux/macOS
  ```bash
  ./setup-autorun.sh --help    # Show help
  ./setup-autorun.sh           # Run setup
  ```

- **`setup-autorun.ps1`**: Automated setup for Windows PowerShell
  ```powershell
  .\setup-autorun.ps1 -Help   # Show help
  .\setup-autorun.ps1          # Run setup
  ```

### Uninstall Scripts

- **`uninstall-autorun.sh`**: Remove auto-run configuration (Unix/Linux/macOS)
  ```bash
  ./uninstall-autorun.sh       # Remove from all detected shells
  ```

- **`uninstall-autorun.ps1`**: Remove auto-run configuration (Windows PowerShell)
  ```powershell
  .\uninstall-autorun.ps1      # Remove from PowerShell profiles
  .\uninstall-autorun.ps1 -Force  # Skip confirmations
  ```

- **`uninstall-autorun.bat`**: Remove auto-run configuration (Windows Command Prompt)
  ```cmd
  uninstall-autorun.bat        # Remove from Windows shell configurations
  ```

### Safety Features

- ✅ **Terminal-safe**: Scripts won't crash your terminal
- ✅ **Backup creation**: Automatic backups of RC files
- ✅ **Recursion prevention**: Built-in safety checks
- ✅ **Graceful fallbacks**: Handles permission and npm link issues
- ✅ **Cross-platform**: Works on macOS, Linux, Windows WSL

## Acknowledgments

- Bible text provided by [Bible API](https://github.com/wldeh/bible-api)
- Built with TypeScript and Node.js
- Terminal colors powered by the [colors](https://www.npmjs.com/package/colors) package
- Interactive terminal UI powered by the [blessed](https://www.npmjs.com/package/blessed) library

---

**Enjoy reading God's Word in your terminal!** 🙏
