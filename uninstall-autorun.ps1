# Bible Line Auto-Run Uninstall Script for PowerShell
# This script removes Bible Line from your PowerShell profile

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
    Gray = "DarkGray"
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
    Write-ColorText "║                Bible Line Uninstall                         ║" -Color Cyan
    Write-ColorText "║            Remove Auto-Run Configuration                    ║" -Color Cyan
    Write-ColorText "║        (Scrollable Interface & Traditional Output)          ║" -Color Cyan
    Write-ColorText "╚══════════════════════════════════════════════════════════════╝" -Color Cyan
    Write-Host ""
}

function Show-Help {
    Write-ColorText "Bible Line PowerShell Uninstall Script" -Color Cyan
    Write-Host ""
    Write-ColorText "Usage:" -Color Yellow
    Write-Host "  .\uninstall-autorun.ps1 [options]"
    Write-Host ""
    Write-ColorText "Options:" -Color Yellow
    Write-Host "  -Force    Skip confirmation prompts"
    Write-Host "  -Help     Show this help message"
    Write-Host ""
    Write-ColorText "Examples:" -Color Yellow
    Write-Host "  .\uninstall-autorun.ps1"
    Write-Host "  .\uninstall-autorun.ps1 -Force"
    Write-Host ""
    Write-ColorText "This script will:" -Color Blue
    Write-Host "  • Detect PowerShell profile configurations"
    Write-Host "  • Create a backup of your profile"
    Write-Host "  • Remove Bible Line configuration"
    Write-Host "  • Optionally remove global npm package"
    Write-Host ""
}

function Get-PowerShellProfiles {
    # Get all possible PowerShell profile paths
    $profiles = @()
    
    # Current user profiles
    if ($PROFILE.CurrentUserCurrentHost) { $profiles += $PROFILE.CurrentUserCurrentHost }
    if ($PROFILE.CurrentUserAllHosts) { $profiles += $PROFILE.CurrentUserAllHosts }
    
    # All users profiles (if accessible)
    try {
        if ($PROFILE.AllUsersCurrentHost) { $profiles += $PROFILE.AllUsersCurrentHost }
        if ($PROFILE.AllUsersAllHosts) { $profiles += $PROFILE.AllUsersAllHosts }
    } catch {
        # Ignore if we can't access all users profiles
    }
    
    # Return only existing profiles
    return $profiles | Where-Object { Test-Path $_ } | Sort-Object -Unique
}

function Test-BibleLineConfig {
    param([string]$ProfilePath)
    
    if (Test-Path $ProfilePath) {
        $content = Get-Content $ProfilePath -Raw -ErrorAction SilentlyContinue
        if ($content) {
            return $content -match "Bible Line|bible-line|npm start.*bible-line|Random Bible verse"
        }
    }
    return $false
}

function Backup-Profile {
    param([string]$ProfilePath)
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupPath = "$ProfilePath.bible-line-removal-backup-$timestamp"
    
    try {
        Copy-Item $ProfilePath $backupPath -ErrorAction Stop
        Write-ColorText "✓ Backup created: $backupPath" -Color Green
        return $true
    } catch {
        Write-ColorText "✗ Failed to create backup: $($_.Exception.Message)" -Color Red
        return $false
    }
}

function Remove-BibleLineConfig {
    param([string]$ProfilePath)
    
    Write-ColorText "Processing $ProfilePath..." -Color Blue
    
    # Create backup first
    if (-not (Backup-Profile $ProfilePath)) {
        Write-ColorText "Skipping $ProfilePath due to backup failure" -Color Yellow
        return $false
    }
    
    try {
        # Read the profile content
        $content = Get-Content $ProfilePath -ErrorAction Stop
        
        # Filter out Bible Line related content
        $filteredContent = @()
        $inBibleLineBlock = $false
        $blockDepth = 0
        
        foreach ($line in $content) {
            $trimmedLine = $line.Trim()
            
            # Check if we're starting a Bible Line block
            if ($trimmedLine -match "# Bible Line") {
                $inBibleLineBlock = $true
                continue
            }
            
            # If we're in a Bible Line block
            if ($inBibleLineBlock) {
                # Skip Bible Line related patterns
                if ($trimmedLine -match "bible-line|npm start.*bible-line|Random Bible verse|terminal startup") {
                    continue
                }
                
                # Handle block structure
                if ($trimmedLine -match "^try\s*{|^if\s*\(") {
                    $blockDepth++
                    continue
                }
                
                if ($trimmedLine -match "^}|^Pop-Location") {
                    if ($blockDepth -gt 0) {
                        $blockDepth--
                        if ($blockDepth -eq 0) {
                            $inBibleLineBlock = $false
                        }
                    } else {
                        $inBibleLineBlock = $false
                    }
                    continue
                }
                
                # Skip other lines in the block
                if ($trimmedLine -match "Set-Location|Test-Path|catch|Silently ignore|^\s*$") {
                    continue
                }
                
                # If it's an empty line and we're still in block, end the block
                if ($trimmedLine -eq "" -and $blockDepth -eq 0) {
                    $inBibleLineBlock = $false
                    continue
                }
                
                # Skip any other content in the block
                continue
            }
            
            # Keep lines that are not part of Bible Line configuration
            $filteredContent += $line
        }
        
        # Write the filtered content back
        $filteredContent | Set-Content $ProfilePath -ErrorAction Stop
        Write-ColorText "✓ Bible Line configuration removed from $ProfilePath" -Color Green
        return $true
        
    } catch {
        Write-ColorText "✗ Failed to process $ProfilePath`: $($_.Exception.Message)" -Color Red
        return $false
    }
}

function Test-GlobalExecutable {
    try {
        $null = Get-Command "bible-line" -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

function Remove-GlobalExecutable {
    Write-ColorText "Removing global executable..." -Color Blue
    
    try {
        # Try npm uninstall first
        $result = npm uninstall -g bible-line 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-ColorText "✓ Global executable removed" -Color Green
            return $true
        } else {
            Write-ColorText "! Could not automatically remove global executable." -Color Yellow
            Write-ColorText "You may need to run: npm uninstall -g bible-line" -Color Yellow
            Write-ColorText "Or if installed with npm link: npm unlink -g bible-line" -Color Yellow
            return $false
        }
    } catch {
        Write-ColorText "! Could not automatically remove global executable." -Color Yellow
        Write-ColorText "Error: $($_.Exception.Message)" -Color Yellow
        return $false
    }
}

function Confirm-Action {
    param([string]$Message)
    
    if ($Force) {
        return $true
    }
    
    $response = Read-Host "$Message (y/N)"
    return ($response -match "^[Yy]")
}

function Show-ManualUsage {
    Write-Host ""
    if (Test-GlobalExecutable) {
        Write-ColorText "You can still run Bible Line manually with:" -Color Blue
        Write-ColorText "bible-line                    # Scrollable interface (default)" -Color Cyan
        Write-ColorText "bible-line --console          # Traditional console output" -Color Cyan
    } else {
        Write-ColorText "To run Bible Line manually, use:" -Color Blue
        Write-ColorText "npm start                     # Scrollable interface (default)" -Color Cyan
        Write-ColorText "npm start -- --console        # Traditional console output" -Color Cyan
        Write-ColorText "(from the project directory)" -Color Gray
    }
}

function Main {
    if ($Help) {
        Show-Help
        return
    }
    
    Show-Header
    
    # Get all PowerShell profiles
    $profiles = Get-PowerShellProfiles
    
    if ($profiles.Count -eq 0) {
        Write-ColorText "No PowerShell profiles found." -Color Yellow
        return
    }
    
    Write-ColorText "Checking for Bible Line configurations..." -Color Blue
    Write-Host ""
    
    # Check each profile for Bible Line configuration
    $foundConfigs = @()
    foreach ($profile in $profiles) {
        if (Test-BibleLineConfig $profile) {
            Write-ColorText "Found Bible Line configuration in: $profile" -Color Yellow
            $foundConfigs += $profile
        }
    }
    
    if ($foundConfigs.Count -eq 0) {
        Write-ColorText "✓ No Bible Line configurations found." -Color Green
        Write-ColorText "Bible Line auto-run is not currently installed." -Color Blue
        return
    }
    
    Write-Host ""
    Write-ColorText "This will remove Bible Line auto-run from your PowerShell profile(s)." -Color Yellow
    
    if (-not (Confirm-Action "Do you want to proceed?")) {
        Write-ColorText "Uninstall cancelled. No changes made." -Color Blue
        return
    }
    
    Write-Host ""
    
    # Remove from each profile that has it
    $successCount = 0
    foreach ($profile in $foundConfigs) {
        if (Remove-BibleLineConfig $profile) {
            $successCount++
        }
    }
    
    Write-Host ""
    Write-ColorText "╔══════════════════════════════════════════════════════════════╗" -Color Green
    Write-ColorText "║                  Uninstall Complete!                        ║" -Color Green
    Write-ColorText "╚══════════════════════════════════════════════════════════════╝" -Color Green
    Write-Host ""
    
    if ($successCount -gt 0) {
        Write-ColorText "✓ Bible Line auto-run has been removed from $successCount profile(s)" -Color Green
        Write-ColorText "✓ Both scrollable interface and console output modes are now disabled" -Color Green
        Write-ColorText "✓ Backup files have been created for safety" -Color Green
    }
    
    # Ask if user wants to remove the global executable
    if (Test-GlobalExecutable) {
        Write-Host ""
        Write-ColorText "The bible-line global executable is still installed." -Color Yellow
        
        if (Confirm-Action "Do you want to remove the global executable as well?") {
            Remove-GlobalExecutable | Out-Null
        }
    }
    
    Write-Host ""
    Write-ColorText "To activate the changes immediately:" -Color Yellow
    Write-ColorText ". `$PROFILE" -Color Cyan
    Write-Host ""
    Write-ColorText "Or simply open a new PowerShell window." -Color Yellow
    
    Show-ManualUsage
}

# Run main function
try {
    Main
} catch {
    Write-ColorText "An error occurred: $($_.Exception.Message)" -Color Red
    Write-ColorText "Please try running the script as Administrator or check the error above." -Color Yellow
    exit 1
}
