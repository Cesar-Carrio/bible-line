#!/bin/bash

# Bible Line Auto-Run Setup Script
# This script automatically adds Bible Line to your shell's RC file
# so it runs every time you open a new terminal session.

# Note: Removed 'set -e' to prevent terminal crashes on non-critical errors
# We'll handle errors explicitly where needed

# Safety checks to prevent crashes
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Script is being executed directly, not sourced
    :
else
    echo "Error: This script should be executed, not sourced."
    return 1 2>/dev/null || exit 1
fi

# Prevent running during shell initialization
if [[ -n "$BIBLE_LINE_SETUP_RUNNING" ]]; then
    echo "Error: Bible Line setup is already running. Avoiding recursion."
    exit 1
fi
export BIBLE_LINE_SETUP_RUNNING=1

# Cleanup function
cleanup() {
    unset BIBLE_LINE_SETUP_RUNNING
}
trap cleanup EXIT

# Check for help flag
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Bible Line Auto-Run Setup Script"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo "  --force       Skip confirmation prompts (future feature)"
    echo ""
    echo "This script will:"
    echo "  • Detect your shell (zsh, bash, fish)"
    echo "  • Create a backup of your RC file"
    echo "  • Add Bible Line configuration to run on terminal startup"
    echo "  • Show you exactly what will be added before making changes"
    echo ""
    echo "Supported shells: zsh, bash, fish"
    echo "Supported systems: macOS, Linux, Windows WSL"
    echo ""
    exit 0
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_PATH="$SCRIPT_DIR"

# Bible Line executable command with safeguards
# Check if timeout command is available (Linux vs macOS)
if command -v timeout >/dev/null 2>&1; then
    TIMEOUT_CMD="timeout 10s"
elif command -v gtimeout >/dev/null 2>&1; then
    TIMEOUT_CMD="gtimeout 10s"
else
    TIMEOUT_CMD=""
fi

BIBLE_LINE_COMMAND="# Bible Line execution with safeguards
if [[ -z \"\$BIBLE_LINE_RUNNING\" ]]; then
    export BIBLE_LINE_RUNNING=1
    $TIMEOUT_CMD bible-line 2>/dev/null || true
    unset BIBLE_LINE_RUNNING
fi"

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                    Bible Line Setup                         ║${NC}"
echo -e "${CYAN}║              Auto-Run Configuration Script                  ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo

# Function to detect the current shell
detect_shell() {
    local shell_name
    
    # Check SHELL environment variable first
    if [[ -n "$SHELL" ]]; then
        shell_name=$(basename "$SHELL")
    else
        # Fallback methods with better error handling
        shell_name=$(ps -p $PPID -o comm= 2>/dev/null) || \
        shell_name=$(ps -o comm= -p $PPID 2>/dev/null) || \
        shell_name="unknown"
    fi
    
    # Clean up shell name and make detection more robust
    shell_name=$(echo "$shell_name" | tr -d ' \n\r')
    
    case "$shell_name" in
        *zsh*|zsh)
            echo "zsh"
            ;;
        *bash*|bash)
            echo "bash"
            ;;
        *fish*|fish)
            echo "fish"
            ;;
        *)
            # Additional fallback - check if we're running in a known shell
            if [[ -n "$ZSH_VERSION" ]]; then
                echo "zsh"
            elif [[ -n "$BASH_VERSION" ]]; then
                echo "bash"
            elif [[ -n "$FISH_VERSION" ]]; then
                echo "fish"
            else
                echo "unknown"
            fi
            ;;
    esac
}

# Function to get the RC file path for each shell
get_rc_file() {
    local shell_type="$1"
    local rc_file=""
    
    case "$shell_type" in
        "zsh")
            rc_file="$HOME/.zshrc"
            ;;
        "bash")
            # Check which bash RC file exists or should be used
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS prefers .bash_profile
                if [[ -f "$HOME/.bash_profile" ]]; then
                    rc_file="$HOME/.bash_profile"
                else
                    rc_file="$HOME/.bash_profile"  # Create it
                fi
            else
                # Linux prefers .bashrc
                if [[ -f "$HOME/.bashrc" ]]; then
                    rc_file="$HOME/.bashrc"
                else
                    rc_file="$HOME/.bashrc"  # Create it
                fi
            fi
            ;;
        "fish")
            rc_file="$HOME/.config/fish/config.fish"
            # Ensure the directory exists
            mkdir -p "$(dirname "$rc_file")"
            ;;
        *)
            return 1
            ;;
    esac
    
    echo "$rc_file"
}

# Function to create backup of RC file
backup_rc_file() {
    local rc_file="$1"
    local backup_file="${rc_file}.bible-line-backup-$(date +%Y%m%d-%H%M%S)"
    
    if [[ -f "$rc_file" ]]; then
        cp "$rc_file" "$backup_file"
        echo -e "${GREEN}✓${NC} Backup created: $backup_file"
        return 0
    else
        echo -e "${YELLOW}!${NC} No existing RC file found, will create new one"
        return 1
    fi
}

# Function to check if Bible Line is already configured
check_existing_config() {
    local rc_file="$1"
    
    if [[ -f "$rc_file" ]] && grep -q "bible-line" "$rc_file"; then
        return 0  # Found existing config
    else
        return 1  # No existing config
    fi
}

# Function to add Bible Line to RC file
add_to_rc_file() {
    local shell_type="$1"
    local rc_file="$2"
    local comment="# Bible Line - Random Bible verse on terminal startup"
    
    echo -e "${BLUE}Adding Bible Line to $rc_file...${NC}"
    
    # Ensure the file exists
    touch "$rc_file"
    
    # Add a blank line if file is not empty and doesn't end with newline
    if [[ -s "$rc_file" ]] && [[ $(tail -c1 "$rc_file" | wc -l) -eq 0 ]]; then
        echo "" >> "$rc_file"
    fi
    
    # Add our configuration
    echo "" >> "$rc_file"
    echo "$comment" >> "$rc_file"
    
    case "$shell_type" in
        "zsh"|"bash")
            cat >> "$rc_file" << EOF
# Bible Line execution with safeguards
if [[ -z "\$BIBLE_LINE_RUNNING" && \$- == *i* ]]; then
    export BIBLE_LINE_RUNNING=1
    $TIMEOUT_CMD bible-line 2>/dev/null || true
    unset BIBLE_LINE_RUNNING
fi
EOF
            ;;
        "fish")
            cat >> "$rc_file" << EOF
# Bible Line execution with safeguards
if not set -q BIBLE_LINE_RUNNING
    set -gx BIBLE_LINE_RUNNING 1
    $TIMEOUT_CMD bible-line 2>/dev/null; or true
    set -e BIBLE_LINE_RUNNING
end
EOF
            ;;
    esac
    
    echo -e "${GREEN}✓${NC} Bible Line added to $rc_file"
}

# Function to remove existing Bible Line configuration
remove_existing_config() {
    local rc_file="$1"
    local temp_file=$(mktemp)
    
    # More comprehensive removal of Bible Line related content
    if [[ -f "$rc_file" ]]; then
        # Remove Bible Line blocks and related lines
        awk '
        /# Bible Line/ { in_block=1; next }
        /BIBLE_LINE_RUNNING/ && in_block { next }
        /bible-line/ && in_block { next }
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
        /^[[:space:]]*end$/ && in_block { in_block=0; next }
        in_block { next }
        { print }
        ' "$rc_file" > "$temp_file"
        
        mv "$temp_file" "$rc_file"
        echo -e "${YELLOW}✓${NC} Removed existing Bible Line configuration"
    else
        rm -f "$temp_file"
    fi
}

# Main setup function
main() {
    echo -e "${BLUE}Detecting your shell environment...${NC}"
    
    # Detect shell
    local shell_type
    shell_type=$(detect_shell)
    
    if [[ "$shell_type" == "unknown" ]]; then
        echo -e "${RED}✗${NC} Could not detect your shell type."
        echo -e "${YELLOW}Supported shells: zsh, bash, fish${NC}"
        echo -e "${YELLOW}Current shell: $SHELL${NC}"
        echo
        echo "Please manually add this line to your shell's RC file:"
        echo -e "${CYAN}$BIBLE_LINE_COMMAND${NC}"
        echo
        echo -e "${BLUE}Setup will exit now. You can run the script again or set up manually.${NC}"
        exit 0  # Changed to exit 0 instead of exit 1 to prevent terminal closure
    fi
    
    echo -e "${GREEN}✓${NC} Detected shell: $shell_type"
    
    # Get RC file path
    local rc_file
    rc_file=$(get_rc_file "$shell_type")
    
    if [[ -z "$rc_file" ]]; then
        echo -e "${RED}✗${NC} Could not determine RC file for $shell_type"
        echo -e "${BLUE}Setup will exit now. Please check your shell configuration.${NC}"
        exit 0  # Changed to exit 0 instead of exit 1
    fi
    
    echo -e "${GREEN}✓${NC} RC file: $rc_file"
    echo
    
    # Check for existing configuration
    if check_existing_config "$rc_file"; then
        echo -e "${YELLOW}!${NC} Bible Line configuration already exists in $rc_file"
        echo
        read -p "Do you want to replace it? (y/N): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            backup_rc_file "$rc_file"
            remove_existing_config "$rc_file"
        else
            echo -e "${BLUE}Setup cancelled. No changes made.${NC}"
            exit 0
        fi
    fi
    
    # Show what will be added
    echo -e "${BLUE}The following will be added to your $rc_file:${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "# Bible Line - Random Bible verse on terminal startup"
    
    case "$shell_type" in
        "zsh"|"bash")
            echo "# Bible Line execution with safeguards"
            echo "if [[ -z \"\$BIBLE_LINE_RUNNING\" && \$- == *i* ]]; then"
            echo "    export BIBLE_LINE_RUNNING=1"
            echo "    $TIMEOUT_CMD bible-line 2>/dev/null || true"
            echo "    unset BIBLE_LINE_RUNNING"
            echo "fi"
            ;;
        "fish")
            echo "# Bible Line execution with safeguards"
            echo "if not set -q BIBLE_LINE_RUNNING"
            echo "    set -gx BIBLE_LINE_RUNNING 1"
            echo "    $TIMEOUT_CMD bible-line 2>/dev/null; or true"
            echo "    set -e BIBLE_LINE_RUNNING"
            echo "end"
            ;;
    esac
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
    
    # Confirm with user
    read -p "Do you want to proceed? (Y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${BLUE}Setup cancelled. No changes made.${NC}"
        exit 0
    fi
    
    # Create backup if file exists
    backup_rc_file "$rc_file"
    
    # Add configuration
    add_to_rc_file "$shell_type" "$rc_file"
    
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                     Setup Complete!                         ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${GREEN}✓${NC} Bible Line has been added to your $shell_type configuration"
    echo -e "${GREEN}✓${NC} A random Bible verse will now appear when you open new terminals"
    echo
    echo -e "${YELLOW}To activate immediately, run:${NC}"
    echo -e "${CYAN}source $rc_file${NC}"
    echo
    echo -e "${YELLOW}Or simply open a new terminal window.${NC}"
    echo
    echo -e "${BLUE}To remove this feature later, edit $rc_file and remove the Bible Line section.${NC}"
}

# Check if we're in the right directory
if [[ ! -f "$PROJECT_PATH/package.json" ]] || ! grep -q "bible-line" "$PROJECT_PATH/package.json" 2>/dev/null; then
    echo -e "${RED}✗${NC} This script must be run from the bible-line project directory."
    echo -e "${YELLOW}Current directory: $PROJECT_PATH${NC}"
    echo -e "${YELLOW}Please cd to the bible-line directory and run this script again.${NC}"
    exit 1
fi

# Check if npm dependencies are installed
if [[ ! -d "$PROJECT_PATH/node_modules" ]]; then
    echo -e "${YELLOW}!${NC} Node modules not found. Installing dependencies..."
    if npm install; then
        echo -e "${GREEN}✓${NC} Dependencies installed"
    else
        echo -e "${RED}✗${NC} Failed to install dependencies. Please run 'npm install' manually."
        echo -e "${YELLOW}Exiting setup...${NC}"
        exit 1
    fi
    echo
fi

# Check if project is built
if [[ ! -f "$PROJECT_PATH/dist/index.js" ]]; then
    echo -e "${YELLOW}!${NC} Project not built. Building now..."
    if npm run build; then
        echo -e "${GREEN}✓${NC} Project built successfully"
    else
        echo -e "${RED}✗${NC} Failed to build project. Please run 'npm run build' manually."
        echo -e "${YELLOW}Exiting setup...${NC}"
        exit 1
    fi
    echo
fi

# Create global executable link
echo -e "${BLUE}Setting up bible-line as a global executable...${NC}"
if ! command -v bible-line >/dev/null 2>&1; then
    echo -e "${YELLOW}!${NC} Creating global link for bible-line executable..."
    
    # Try npm link without sudo first
    if npm link 2>/dev/null; then
        echo -e "${GREEN}✓${NC} Global executable 'bible-line' created successfully"
    else
        echo -e "${YELLOW}!${NC} npm link failed, trying with sudo..."
        
        # Try with sudo
        if sudo npm link 2>/dev/null; then
            echo -e "${GREEN}✓${NC} Global executable 'bible-line' created successfully (with sudo)"
        else
            echo -e "${YELLOW}!${NC} Could not create global executable link automatically."
            echo -e "${YELLOW}You can create it manually later with: sudo npm link${NC}"
            echo -e "${BLUE}Continuing with setup using project directory path...${NC}"
            
            # Fallback to project directory approach
            BIBLE_LINE_COMMAND="# Bible Line execution with safeguards (fallback to project directory)
if [[ -z \"\$BIBLE_LINE_RUNNING\" ]]; then
    export BIBLE_LINE_RUNNING=1
    (cd \"$PROJECT_PATH\" && $TIMEOUT_CMD npm start --silent 2>/dev/null) || true
    unset BIBLE_LINE_RUNNING
fi"
        fi
    fi
else
    echo -e "${GREEN}✓${NC} bible-line executable is already available globally"
fi
echo

# Run main setup
main

echo -e "${CYAN}Thank you for using Bible Line! 📖✨${NC}"
