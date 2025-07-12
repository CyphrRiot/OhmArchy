#!/usr/bin/env bash
# ==============================================================================
# OhmArchy Fish Shell Immediate Fix Script
# ==============================================================================
# Fixes fish shell configuration and ensures custom prompt loads
# ==============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${PURPLE}🐟 OhmArchy Fish Shell Fix${NC}"
echo -e "${PURPLE}=========================${NC}"
echo ""

# Check if OhmArchy is installed
if [ ! -d ~/.local/share/omarchy ]; then
    echo -e "${RED}❌ OhmArchy not found! Run the installer first:${NC}"
    echo -e "${RED}   curl -fsSL https://cyphrriot.github.io/OhmArchy/setup.sh | bash${NC}"
    exit 1
fi

# Check if fish is installed
if ! command -v fish &> /dev/null; then
    echo -e "${RED}❌ Fish shell not installed! Installing now...${NC}"
    if command -v yay &> /dev/null; then
        yay -S --noconfirm --needed fish
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm --needed fish
    else
        echo -e "${RED}❌ Cannot install fish. Please install manually.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Fish shell is installed${NC}"

# Check current default shell
current_shell=$(echo $SHELL)
echo -e "${YELLOW}Current shell: $current_shell${NC}"

# Force fish configuration setup
echo ""
echo -e "${CYAN}🔧 Forcing Fish Configuration...${NC}"
echo "--------------------------------"

# Backup existing fish config if it exists
if [ -f ~/.config/fish/config.fish ]; then
    echo -e "${YELLOW}Backing up existing fish config...${NC}"
    cp ~/.config/fish/config.fish ~/.config/fish/config.fish.backup.$(date +%s)
fi

# Ensure fish config directory exists
mkdir -p ~/.config/fish
mkdir -p ~/.config/fish/completions

# Force copy of OhmArchy fish configuration
echo -e "${YELLOW}Copying OhmArchy fish configuration...${NC}"
if [ -f ~/.local/share/omarchy/config/fish/config.fish ]; then
    cp ~/.local/share/omarchy/config/fish/config.fish ~/.config/fish/config.fish
    echo -e "${GREEN}✓ Fish configuration copied${NC}"
else
    echo -e "${RED}❌ OhmArchy fish config not found!${NC}"
    echo -e "${RED}   Expected: ~/.local/share/omarchy/config/fish/config.fish${NC}"
    exit 1
fi

# Validate fish config file
if [ -f ~/.config/fish/config.fish ]; then
    echo -e "${GREEN}✓ Fish config file exists${NC}"

    # Test if fish config loads without errors
    if fish -c "source ~/.config/fish/config.fish; echo 'Config test successful'" &> /dev/null; then
        echo -e "${GREEN}✓ Fish configuration loads without errors${NC}"
    else
        echo -e "${RED}❌ Fish configuration has syntax errors${NC}"
        echo -e "${YELLOW}Testing fish config...${NC}"
        fish -c "source ~/.config/fish/config.fish" || true
    fi
else
    echo -e "${RED}❌ Fish config file missing after copy${NC}"
    exit 1
fi

# Set fish as default shell if not already
if [[ "$SHELL" != *"fish"* ]]; then
    echo ""
    echo -e "${YELLOW}Setting fish as default shell...${NC}"

    # Check if fish path exists in /etc/shells
    if ! grep -q "$(which fish)" /etc/shells; then
        echo -e "${YELLOW}Adding fish to /etc/shells...${NC}"
        which fish | sudo tee -a /etc/shells
    fi

    # Change default shell
    sudo chsh -s "$(which fish)" "$USER"
    echo -e "${GREEN}✓ Fish set as default shell${NC}"
    echo -e "${YELLOW}⚠ Shell change will take effect on next login${NC}"
else
    echo -e "${GREEN}✓ Fish is already the default shell${NC}"
fi

# Force reload fish configuration in current session
echo ""
echo -e "${CYAN}🔄 Testing Fish Configuration...${NC}"
echo "-------------------------------"

# Test specific features of OhmArchy fish config
echo -e "${YELLOW}Testing OhmArchy fish features...${NC}"

# Check for custom greeting function
if fish -c "functions -q fish_greeting" &> /dev/null; then
    echo -e "${GREEN}✓ Custom fish greeting function found${NC}"
else
    echo -e "${RED}❌ Custom fish greeting function missing${NC}"
fi

# Check for custom aliases
if fish -c "alias | grep -q eza" &> /dev/null; then
    echo -e "${GREEN}✓ Custom aliases loaded (eza)${NC}"
else
    echo -e "${RED}❌ Custom aliases not loaded${NC}"
fi

# Check for zoxide integration
if fish -c "functions -q z" &> /dev/null; then
    echo -e "${GREEN}✓ Zoxide integration loaded${NC}"
else
    echo -e "${YELLOW}⚠ Zoxide integration not loaded (may need zoxide installed)${NC}"
fi

# Test fastfetch availability for greeting
if command -v fastfetch &> /dev/null; then
    echo -e "${GREEN}✓ Fastfetch available for greeting${NC}"
else
    echo -e "${YELLOW}⚠ Fastfetch not found (installing...)${NC}"
    if command -v yay &> /dev/null; then
        yay -S --noconfirm --needed fastfetch || true
    fi
fi

echo ""
echo -e "${CYAN}📋 Fish Configuration Summary:${NC}"
echo "=============================="

# Show current shell
echo -e "${BLUE}Current shell:${NC} $SHELL"
echo -e "${BLUE}Fish location:${NC} $(which fish)"
echo -e "${BLUE}Fish config:${NC} ~/.config/fish/config.fish"

# Show config file size and modification time
if [ -f ~/.config/fish/config.fish ]; then
    config_size=$(wc -l < ~/.config/fish/config.fish)
    config_time=$(stat -c %Y ~/.config/fish/config.fish)
    config_date=$(date -d @$config_time)
    echo -e "${BLUE}Config lines:${NC} $config_size"
    echo -e "${BLUE}Last modified:${NC} $config_date"
fi

echo ""
echo -e "${GREEN}🎉 Fish Configuration Fix Complete!${NC}"
echo ""

# Provide next steps
echo -e "${PURPLE}📝 NEXT STEPS:${NC}"
echo "============="
echo ""

if [[ "$SHELL" != *"fish"* ]]; then
    echo -e "${YELLOW}1. LOGOUT and LOGIN again to activate fish as default shell${NC}"
    echo -e "${YELLOW}2. OR start a new fish session now: ${CYAN}fish${NC}"
else
    echo -e "${YELLOW}1. Start a new fish session: ${CYAN}fish${NC}"
    echo -e "${YELLOW}2. OR close terminal and open a new one${NC}"
fi

echo ""
echo -e "${BLUE}You should see:${NC}"
echo -e "${BLUE}  - Custom OhmArchy greeting with Arch logo${NC}"
echo -e "${BLUE}  - Enhanced aliases (ls → eza, cat → bat, etc.)${NC}"
echo -e "${BLUE}  - Smart directory jumping with 'z' command${NC}"
echo -e "${BLUE}  - Git shortcuts (gs, ga, gc, etc.)${NC}"
echo -e "${BLUE}  - Beautiful syntax highlighting${NC}"
echo ""

echo -e "${CYAN}To test fish config immediately:${NC}"
echo -e "${CYAN}  fish -c 'fish_greeting'${NC}"
echo ""

# Offer to start fish immediately
read -p "Start fish shell now to test configuration? (Y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${GREEN}Starting fish with OhmArchy configuration...${NC}"
    echo ""
    exec fish
fi

echo -e "${PURPLE}Fish configuration fix completed! Start a new shell session to see changes.${NC}"
