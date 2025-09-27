@echo off
REM Bible Line Auto-Run Uninstall Script for Windows Command Prompt
REM This script removes Bible Line from common Windows shell configurations

setlocal enabledelayedexpansion

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                Bible Line Uninstall                         ║
echo ║            Remove Auto-Run Configuration                    ║
echo ║        (Scrollable Interface ^& Traditional Output)          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Check for help parameter
if /i "%1"=="--help" goto :show_help
if /i "%1"=="-h" goto :show_help
if /i "%1"=="/?" goto :show_help

REM Check if we're in the right directory
if not exist "package.json" (
    echo [ERROR] This script must be run from the bible-line project directory.
    echo Current directory: %CD%
    echo Please navigate to the bible-line directory and run this script again.
    pause
    exit /b 1
)

echo Checking for Bible Line configurations...
echo.

set "found_config=0"

REM Check PowerShell profile (most common)
for /f "tokens=*" %%a in ('powershell -Command "if ($PROFILE.CurrentUserCurrentHost) { $PROFILE.CurrentUserCurrentHost }"') do set "ps_profile=%%a"

if exist "!ps_profile!" (
    findstr /i "bible-line" "!ps_profile!" >nul 2>&1
    if !errorlevel! equ 0 (
        echo Found Bible Line configuration in PowerShell profile: !ps_profile!
        set "found_config=1"
    )
)

REM Check for Windows Terminal settings (less common but possible)
set "wt_settings=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if exist "!wt_settings!" (
    findstr /i "bible-line" "!wt_settings!" >nul 2>&1
    if !errorlevel! equ 0 (
        echo Found Bible Line configuration in Windows Terminal settings
        set "found_config=1"
    )
)

if !found_config! equ 0 (
    echo [OK] No Bible Line configurations found.
    echo Bible Line auto-run is not currently installed.
    echo.
    pause
    exit /b 0
)

echo.
echo This will remove Bible Line auto-run from your shell configuration(s).
set /p "confirm=Do you want to proceed? (y/N): "

if /i not "!confirm!"=="y" (
    echo Uninstall cancelled. No changes made.
    pause
    exit /b 0
)

echo.

REM Remove from PowerShell profile if found
if exist "!ps_profile!" (
    findstr /i "bible-line" "!ps_profile!" >nul 2>&1
    if !errorlevel! equ 0 (
        echo Processing PowerShell profile...
        
        REM Create backup
        set "timestamp=%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%"
        set "timestamp=!timestamp: =0!"
        set "backup_file=!ps_profile!.bible-line-removal-backup-!timestamp!"
        copy "!ps_profile!" "!backup_file!" >nul
        echo [OK] Backup created: !backup_file!
        
        REM Use PowerShell to remove Bible Line configuration
        powershell -Command "& { $content = Get-Content '!ps_profile!'; $filtered = @(); $inBlock = $false; foreach ($line in $content) { if ($line -match '# Bible Line') { $inBlock = $true; continue } if ($inBlock -and ($line -match 'bible-line|npm start|Set-Location|Test-Path|try|catch|Pop-Location' -or $line.Trim() -eq '}' -or $line.Trim() -eq '')) { if ($line.Trim() -eq '}' -and $line -notmatch 'catch') { $inBlock = $false } continue } if (-not $inBlock) { $filtered += $line } } $filtered | Set-Content '!ps_profile!' }"
        
        echo [OK] Bible Line configuration removed from PowerShell profile
    )
)

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                  Uninstall Complete!                        ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo [OK] Bible Line auto-run has been removed from your shell configuration(s)
echo [OK] Both scrollable interface and console output modes are now disabled
echo [OK] Backup files have been created for safety
echo.

REM Check if global executable exists
where bible-line >nul 2>&1
if !errorlevel! equ 0 (
    echo The bible-line global executable is still installed.
    set /p "remove_global=Do you want to remove the global executable as well? (y/N): "
    
    if /i "!remove_global!"=="y" (
        echo Removing global executable...
        npm uninstall -g bible-line 2>nul || npm unlink -g bible-line 2>nul || (
            echo [WARNING] Could not automatically remove global executable.
            echo You may need to run: npm uninstall -g bible-line
        )
    )
)

echo.
echo To activate the changes immediately:
echo . $PROFILE
echo.
echo Or simply open a new PowerShell window.
echo.

where bible-line >nul 2>&1
if !errorlevel! equ 0 (
    echo You can still run Bible Line manually with:
    echo bible-line                    # Scrollable interface (default^)
    echo bible-line --console          # Traditional console output
) else (
    echo To run Bible Line manually, use:
    echo npm start                     # Scrollable interface (default^)
    echo npm start -- --console        # Traditional console output
    echo (from the project directory^)
)

echo.
pause
exit /b 0

:show_help
echo Bible Line Windows Uninstall Script
echo.
echo Usage:
echo   uninstall-autorun.bat [options]
echo.
echo Options:
echo   --help, -h, /?    Show this help message
echo.
echo Examples:
echo   uninstall-autorun.bat
echo.
echo This script will:
echo   • Detect PowerShell profile configurations
echo   • Create a backup of your profile
echo   • Remove Bible Line configuration
echo   • Optionally remove global npm package
echo.
pause
exit /b 0
