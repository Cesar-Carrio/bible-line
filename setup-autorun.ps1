# Bible Line Auto-Run Setup Script for PowerShell
# This script automatically adds Bible Line to your PowerShell profile
# so it runs every time you open a new PowerShell session.

param(
    [switch]$Force,
    [switch]$Help
)

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Blue"
    Cyan = "Cyan"
    White = "White"
}

function Write-ColorText {
    param(
        [string]$Text,
        [string]$Color = "White"
    )
    Write-Host $Text -ForegroundColor $Color
}

function Show-Header {
    Write-ColorText "╔══════════════════════════════════════════════════════════════╗" -Color Cyan
    Write-ColorText "║                    Bible Line Setup                         ║" -Color Cyan
    Write-ColorText "║              Auto-Run Configuration Script                  ║" -Color Cyan
    Write-ColorText "╚══════════════════════════════════════════════════════════════╝" -Color Cyan
    Write-Host ""
}

function Show-Help {
    Write-ColorText "Bible Line PowerShell Setup Script" -Color Cyan
    Write-Host ""
    Write-ColorText "Usage:" -Color Yellow
    Write-Host "  .\setup-autorun.ps1 [options]"
    Write-Host ""
    Write-ColorText "Options:" -Color Yellow
    Write-Host "  -Force    Skip confirmation prompts"
    Write-Host "  -Help     Show this help message"
    Write-Host ""
    Write-ColorText "Examples:" -Color Yellow
    Write-Host "  .\setup-autorun.ps1"
    Write-Host "  .\setup-autorun.ps1 -Force"
    Write-Host ""
}

function Test-Prerequisites {
    # Check if we're in the right directory
    if (-not (Test-Path "package.json") -or -not (Select-String -Path "package.json" -Pattern "bible-line" -Quiet)) {
        Write-ColorText "✗ This script must be run from the bible-line project directory." -Color Red
        Write-ColorText "Current directory: $(Get-Location)" -Color Yellow
        Write-ColorText "Please navigate to the bible-line directory and run this script again." -Color Yellow
        exit 1
    }

    # Check if Node.js is installed
    try {
        $nodeVersion = node --version 2>$null
        Write-ColorText "✓ Node.js found: $nodeVersion" -Color Green
    } catch {
        Write-ColorText "✗ Node.js is not installed or not in PATH." -Color Red
        Write-ColorText "Please install Node.js from https://nodejs.org/" -Color Yellow
        exit 1
    }

    # Check if npm dependencies are installed
    if (-not (Test-Path "node_modules")) {
        Write-ColorText "! Node modules not found. Installing dependencies..." -Color Yellow
        npm install
        Write-ColorText "✓ Dependencies installed" -Color Green
        Write-Host ""
    }

    # Check if project is built
    if (-not (Test-Path "dist/index.js")) {
        Write-ColorText "! Project not built. Building now..." -Color Yellow
        npm run build
        Write-ColorText "✓ Project built successfully" -Color Green
        Write-Host ""
    }
}

function Get-PowerShellProfile {
    # Return the current user's PowerShell profile path
    return $PROFILE.CurrentUserCurrentHost
}

function Backup-Profile {
    param([string]$ProfilePath)
    
    if (Test-Path $ProfilePath) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupPath = "$ProfilePath.bible-line-backup-$timestamp"
        Copy-Item $ProfilePath $backupPath
        Write-ColorText "✓ Backup created: $backupPath" -Color Green
        return $true
    } else {
        Write-ColorText "! No existing PowerShell profile found, will create new one" -Color Yellow
        return $false
    }
}

function Test-ExistingConfig {
    param([string]$ProfilePath)
    
    if (Test-Path $ProfilePath) {
        $content = Get-Content $ProfilePath -Raw
        return $content -match "bible-line"
    }
    return $false
}

function Remove-ExistingConfig {
    param([string]$ProfilePath)
    
    if (Test-Path $ProfilePath) {
        $content = Get-Content $ProfilePath
        $filteredContent = $content | Where-Object { $_ -notmatch "bible-line" -and $_ -notmatch [regex]::Escape($ProjectPath) }
        $filteredContent | Set-Content $ProfilePath
        Write-ColorText "✓ Removed existing Bible Line configuration" -Color Yellow
    }
}

function Add-BibleLineToProfile {
    param([string]$ProfilePath)
    
    Write-ColorText "Adding Bible Line to PowerShell profile..." -Color Blue
    
    # Ensure the profile directory exists
    $profileDir = Split-Path $ProfilePath -Parent
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    
    # Ensure the profile file exists
    if (-not (Test-Path $ProfilePath)) {
        New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
    }
    
    # Add our configuration
    $configLines = @(
        "",
        "# Bible Line - Random Bible verse on terminal startup",
        "try {",
        "    if (Test-Path `"$ProjectPath`") {",
        "        Set-Location `"$ProjectPath`"",
        "        npm start --silent 2>`$null",
        "        Pop-Location",
        "    }",
        "} catch {",
        "    # Silently ignore errors",
        "}",
        ""
    )
    
    Add-Content -Path $ProfilePath -Value $configLines
    Write-ColorText "✓ Bible Line added to PowerShell profile" -Color Green
}

function Show-Preview {
    Write-ColorText "The following will be added to your PowerShell profile:" -Color Blue
    Write-ColorText "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -Color Cyan
    Write-Host "# Bible Line - Random Bible verse on terminal startup"
    Write-Host "try {"
    Write-Host "    if (Test-Path `"$ProjectPath`") {"
    Write-Host "        Set-Location `"$ProjectPath`""
    Write-Host "        npm start --silent 2>`$null"
    Write-Host "        Pop-Location"
    Write-Host "    }"
    Write-Host "} catch {"
    Write-Host "    # Silently ignore errors"
    Write-Host "}"
    Write-ColorText "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -Color Cyan
    Write-Host ""
}

function Confirm-Action {
    param([string]$Message)
    
    if ($Force) {
        return $true
    }
    
    $response = Read-Host "$Message (Y/n)"
    return ($response -eq "" -or $response -match "^[Yy]")
}

function Main {
    if ($Help) {
        Show-Help
        return
    }
    
    Show-Header
    
    # Test prerequisites
    Test-Prerequisites
    
    Write-ColorText "Configuring Bible Line for PowerShell..." -Color Blue
    
    # Get PowerShell profile path
    $profilePath = Get-PowerShellProfile
    Write-ColorText "✓ PowerShell profile: $profilePath" -Color Green
    Write-Host ""
    
    # Check for existing configuration
    if (Test-ExistingConfig $profilePath) {
        Write-ColorText "! Bible Line configuration already exists in PowerShell profile" -Color Yellow
        Write-Host ""
        
        if (Confirm-Action "Do you want to replace it?") {
            Backup-Profile $profilePath | Out-Null
            Remove-ExistingConfig $profilePath
        } else {
            Write-ColorText "Setup cancelled. No changes made." -Color Blue
            return
        }
    }
    
    # Show preview
    Show-Preview
    
    # Confirm with user
    if (-not (Confirm-Action "Do you want to proceed?")) {
        Write-ColorText "Setup cancelled. No changes made." -Color Blue
        return
    }
    
    # Create backup
    Backup-Profile $profilePath | Out-Null
    
    # Add configuration
    Add-BibleLineToProfile $profilePath
    
    Write-Host ""
    Write-ColorText "╔══════════════════════════════════════════════════════════════╗" -Color Green
    Write-ColorText "║                     Setup Complete!                         ║" -Color Green
    Write-ColorText "╚══════════════════════════════════════════════════════════════╝" -Color Green
    Write-Host ""
    Write-ColorText "✓ Bible Line has been added to your PowerShell profile" -Color Green
    Write-ColorText "✓ A random Bible verse will now appear when you open new PowerShell sessions" -Color Green
    Write-Host ""
    Write-ColorText "To activate immediately, run:" -Color Yellow
    Write-ColorText ". `$PROFILE" -Color Cyan
    Write-Host ""
    Write-ColorText "Or simply open a new PowerShell window." -Color Yellow
    Write-Host ""
    Write-ColorText "To remove this feature later, edit your PowerShell profile:" -Color Blue
    Write-ColorText "notepad `$PROFILE" -Color Cyan
    Write-Host ""
    Write-ColorText "Thank you for using Bible Line! 📖✨" -Color Cyan
}

# Get the current project path
$ProjectPath = Get-Location

# Run main function
try {
    Main
} catch {
    Write-ColorText "An error occurred: $($_.Exception.Message)" -Color Red
    Write-ColorText "Please try running the script as Administrator or check the error above." -Color Yellow
    exit 1
}
