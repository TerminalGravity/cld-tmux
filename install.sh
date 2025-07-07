#!/bin/bash
# cld installer script

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Installing cld - Claude tmux Session Manager${NC}"
echo "============================================="

# Check dependencies
check_dependency() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}✗ $1 not found${NC}"
        echo "  Please install $1 first"
        return 1
    else
        echo -e "${GREEN}✓ $1 found${NC}"
        return 0
    fi
}

echo -e "\n${BLUE}Checking dependencies...${NC}"
DEPS_OK=true
check_dependency "tmux" || DEPS_OK=false
check_dependency "claude" || DEPS_OK=false
check_dependency "zsh" || DEPS_OK=false

if [ "$DEPS_OK" = false ]; then
    echo -e "\n${RED}Please install missing dependencies first${NC}"
    exit 1
fi

# Create directories
echo -e "\n${BLUE}Creating directories...${NC}"
mkdir -p "$HOME/scripts"
mkdir -p "$HOME/.config/zsh/completions"
mkdir -p "$HOME/projects"

# Install cld script
echo -e "\n${BLUE}Installing cld...${NC}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cp "$SCRIPT_DIR/cld" "$HOME/scripts/cld"
chmod +x "$HOME/scripts/cld"
echo -e "${GREEN}✓ Installed to ~/scripts/cld${NC}"

# Install completion
if [ -f "$SCRIPT_DIR/completions/_cld" ]; then
    cp "$SCRIPT_DIR/completions/_cld" "$HOME/.config/zsh/completions/_cld"
    echo -e "${GREEN}✓ Installed ZSH completion${NC}"
fi

# Update PATH in shell config
update_shell_config() {
    local shell_config="$1"
    local path_line='export PATH="$HOME/scripts:$PATH"'
    local completion_lines='fpath=(~/.config/zsh/completions $fpath)
autoload -U compinit && compinit'
    
    if [ -f "$shell_config" ]; then
        # Check if PATH is already set
        if ! grep -q 'PATH="$HOME/scripts:$PATH"' "$shell_config"; then
            echo -e "\n# cld - Claude tmux session manager" >> "$shell_config"
            echo "$path_line" >> "$shell_config"
            echo -e "${GREEN}✓ Added ~/scripts to PATH in $shell_config${NC}"
        else
            echo -e "${BLUE}ℹ ~/scripts already in PATH${NC}"
        fi
        
        # Check if completion is set
        if ! grep -q 'fpath=(~/.config/zsh/completions' "$shell_config"; then
            echo -e "\n# ZSH completions" >> "$shell_config"
            echo "$completion_lines" >> "$shell_config"
            echo -e "${GREEN}✓ Added completion setup to $shell_config${NC}"
        fi
    fi
}

echo -e "\n${BLUE}Updating shell configuration...${NC}"
update_shell_config "$HOME/.zshrc"

# Create example configuration
if [ ! -f "$HOME/.config/cld/config" ]; then
    mkdir -p "$HOME/.config/cld"
    cat > "$HOME/.config/cld/config" << EOF
# cld configuration
# Default projects directory
CLD_PROJECTS_DIR="$HOME/projects"
EOF
    echo -e "${GREEN}✓ Created example config at ~/.config/cld/config${NC}"
fi

echo -e "\n${GREEN}Installation complete!${NC}"
echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Reload your shell: source ~/.zshrc"
echo "2. Test the installation: cld -h"
echo "3. Start your first session: cld myproject"
echo -e "\n${BLUE}For more information:${NC}"
echo "https://github.com/terminalgravity/cld-tmux"