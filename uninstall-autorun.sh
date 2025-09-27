#!/bin/bash

# Bible Line Auto-Run Uninstall Script
# This script removes Bible Line from your shell's RC file

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                Bible Line Uninstall                         ║${NC}"
echo -e "${CYAN}║            Remove Auto-Run Configuration                    ║${NC}"
echo -e "${CYAN}║        (Scrollable Interface & Traditional Output)          ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo

# Function to detect shell and get RC file
get_shell_files() {
    local files=()
    
    # Check common RC files
    [[ -f "$HOME/.zshrc" ]] && files+=("$HOME/.zshrc")
    [[ -f "$HOME/.bashrc" ]] && files+=("$HOME/.bashrc")
    [[ -f "$HOME/.bash_profile" ]] && files+=("$HOME/.bash_profile")
    [[ -f "$HOME/.config/fish/config.fish" ]] && files+=("$HOME/.config/fish/config.fish")
    
    printf '%s\n' "${files[@]}"
}

# Function to check if Bible Line is configured
check_bible_line_config() {
    local rc_file="$1"
    grep -q "Bible Line\|BIBLE_LINE_RUNNING\|bible-line\|npm start.*bible-line" "$rc_file" 2>/dev/null
}

# Function to remove Bible Line configuration
remove_bible_line() {
    local rc_file="$1"
    local backup_file="${rc_file}.bible-line-removal-backup-$(date +%Y%m%d-%H%M%S)"
    
    echo -e "${BLUE}Processing $rc_file...${NC}"
    
    # Create backup
    cp "$rc_file" "$backup_file"
    echo -e "${GREEN}✓${NC} Backup created: $backup_file"
    
    # Remove Bible Line configuration (enhanced pattern matching)
    awk '
    /# Bible Line/ { in_block=1; next }
    /BIBLE_LINE_RUNNING/ && in_block { next }
    /bible-line/ && in_block { next }
    /npm start.*bible-line/ && in_block { next }
    /timeout.*bible-line/ && in_block { next }
    /gtimeout.*bible-line/ && in_block { next }
    /Random Bible verse/ && in_block { next }
    /terminal startup/ && in_block { next }
    /cd.*bible-line.*npm start/ && in_block { next }
    /^$/ && in_block { in_block=0; next }
    /^[[:space:]]*#/ && in_block { next }
    /^[[:space:]]*if/ && in_block { 
        brace_count=1
        next
    }
    /^[[:space:]]*fi$/ && in_block && brace_count>0 { 
        brace_count--
        if (brace_count==0) in_block=0
        next
    }
    /^[[:space:]]*\(.*cd.*bible-line/ && in_block { next }
    /^[[:space:]]*export.*BIBLE_LINE/ && in_block { next }
    /^[[:space:]]*unset.*BIBLE_LINE/ && in_block { next }
    /^[[:space:]]*set.*BIBLE_LINE/ && in_block { next }
    /^[[:space:]]*end$/ && in_block { in_block=0; next }
    in_block { next }
    { print }
    ' "$rc_file" > "${rc_file}.tmp"
    
    mv "${rc_file}.tmp" "$rc_file"
    echo -e "${GREEN}✓${NC} Bible Line configuration removed from $rc_file"
}

# Main function
main() {
    local rc_files
    local found_config=false
    
    # Get all potential RC files
    local rc_files_list
    rc_files_list=$(get_shell_files)
    
    # Convert to array using a more compatible method
    local rc_files=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && rc_files+=("$line")
    done <<< "$rc_files_list"
    
    if [[ ${#rc_files[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No shell configuration files found.${NC}"
        exit 0
    fi
    
    echo -e "${BLUE}Checking for Bible Line configurations...${NC}"
    echo
    
    # Check each RC file
    for rc_file in "${rc_files[@]}"; do
        if check_bible_line_config "$rc_file"; then
            echo -e "${YELLOW}Found Bible Line configuration in: $rc_file${NC}"
            found_config=true
        fi
    done
    
    if [[ "$found_config" == false ]]; then
        echo -e "${GREEN}✓${NC} No Bible Line configurations found."
        echo -e "${BLUE}Bible Line auto-run is not currently installed.${NC}"
        exit 0
    fi
    
    echo
    echo -e "${YELLOW}This will remove Bible Line auto-run from your shell configuration(s).${NC}"
    read -p "Do you want to proceed? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Uninstall cancelled. No changes made.${NC}"
        exit 0
    fi
    
    echo
    
    # Remove from each file that has it
    for rc_file in "${rc_files[@]}"; do
        if check_bible_line_config "$rc_file"; then
            remove_bible_line "$rc_file"
        fi
    done
    
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                  Uninstall Complete!                        ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${GREEN}✓${NC} Bible Line auto-run has been removed from your shell configuration(s)"
    echo -e "${GREEN}✓${NC} Both scrollable interface and console output modes are now disabled"
    echo -e "${GREEN}✓${NC} Backup files have been created for safety"
    echo
    
    # Ask if user wants to remove the global executable
    if command -v bible-line >/dev/null 2>&1; then
        echo -e "${YELLOW}The bible-line global executable is still installed.${NC}"
        read -p "Do you want to remove the global executable as well? (y/N): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Removing global executable...${NC}"
            npm unlink -g bible-line 2>/dev/null || sudo npm unlink -g bible-line || {
                echo -e "${YELLOW}Could not automatically remove global executable.${NC}"
                echo -e "${YELLOW}You may need to run: sudo npm unlink -g bible-line${NC}"
            }
            echo -e "${GREEN}✓${NC} Global executable removed"
        fi
    fi
    
    echo
    echo -e "${YELLOW}To activate the changes immediately:${NC}"
    echo -e "${CYAN}source ~/.zshrc${NC}     # For zsh"
    echo -e "${CYAN}source ~/.bashrc${NC}    # For bash"
    echo
    echo -e "${YELLOW}Or simply open a new terminal window.${NC}"
    echo
    if command -v bible-line >/dev/null 2>&1; then
        echo -e "${BLUE}You can still run Bible Line manually with:${NC}"
        echo -e "${CYAN}bible-line${NC}             # Scrollable interface (default)"
        echo -e "${CYAN}bible-line --console${NC}   # Traditional console output"
    else
        echo -e "${BLUE}To run Bible Line manually, use:${NC}"
        echo -e "${CYAN}npm start${NC}              # Scrollable interface (default)"
        echo -e "${CYAN}npm start -- --console${NC} # Traditional console output"
        echo -e "${GRAY}(from the project directory)${NC}"
    fi
}

main "$@"
