#!/usr/bin/env bash
# ==============================================================================
# OhmArchy Theme & LUKS Immediate Fix Script
# ==============================================================================
# Fixes waybar theme and offers LUKS boot image update
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

echo -e "${PURPLE}🔧 OhmArchy Immediate Theme & LUKS Fix${NC}"
echo -e "${PURPLE}=====================================${NC}"
echo ""

# Check if we're in the right place
if [ ! -d ~/.local/share/omarchy ]; then
    echo -e "${RED}❌ OhmArchy not found! Run the installer first:${NC}"
    echo -e "${RED}   curl -fsSL https://cyphrriot.github.io/OhmArchy/setup.sh | bash${NC}"
    exit 1
fi

# Kill waybar to stop conflicts
echo -e "${YELLOW}🔄 Stopping current waybar...${NC}"
pkill waybar || true
sleep 2

# FORCE CypherRiot Theme Application
echo -e "${CYAN}🎨 FORCING CypherRiot Theme Application...${NC}"
echo "----------------------------------------"

# Ensure directories exist
mkdir -p ~/.config/omarchy/current
mkdir -p ~/.config/omarchy/themes
mkdir -p ~/.config/waybar
mkdir -p ~/.config/wofi
mkdir -p ~/.config/mako

# Force theme links
echo -e "${YELLOW}Linking theme directories...${NC}"
for f in ~/.local/share/omarchy/themes/*; do
    if [ -d "$f" ]; then
        theme_name=$(basename "$f")
        rm -f ~/.config/omarchy/themes/$theme_name
        ln -sf "$f" ~/.config/omarchy/themes/$theme_name
    fi
done

# FORCE CypherRiot as current theme
echo -e "${YELLOW}Forcing CypherRiot as active theme...${NC}"
rm -f ~/.config/omarchy/current/theme
ln -sf ~/.config/omarchy/themes/cypherriot ~/.config/omarchy/current/theme

# Force backgrounds setup
echo -e "${YELLOW}Setting up CypherRiot backgrounds...${NC}"
mkdir -p ~/.config/omarchy/backgrounds/cypherriot
if [ -f ~/.local/share/omarchy/themes/cypherriot/backgrounds/cyber.jpg ]; then
    cp ~/.local/share/omarchy/themes/cypherriot/backgrounds/cyber.jpg ~/.config/omarchy/backgrounds/cypherriot/1-cyber.jpg
fi
if [ -f ~/.local/share/omarchy/themes/cypherriot/backgrounds/City-Rainy-Night.png ]; then
    cp ~/.local/share/omarchy/themes/cypherriot/backgrounds/City-Rainy-Night.png ~/.config/omarchy/backgrounds/cypherriot/2-City-Rainy-Night.png
fi

# Force background links
rm -f ~/.config/omarchy/current/backgrounds
ln -sf ~/.config/omarchy/backgrounds/cypherriot ~/.config/omarchy/current/backgrounds
rm -f ~/.config/omarchy/current/background
ln -sf ~/.config/omarchy/current/backgrounds/1-cyber.jpg ~/.config/omarchy/current/background

# FORCE Waybar Configuration
echo -e "${YELLOW}Forcing CypherRiot waybar configuration...${NC}"
rm -f ~/.config/waybar/config
ln -sf ~/.config/omarchy/current/theme/config ~/.config/waybar/config

# Force other app configurations
echo -e "${YELLOW}Applying theme to all applications...${NC}"
rm -f ~/.config/wofi/style.css
ln -sf ~/.config/omarchy/current/theme/wofi.css ~/.config/wofi/style.css

rm -f ~/.config/mako/config
ln -sf ~/.config/omarchy/current/theme/mako.ini ~/.config/mako/config

rm -f ~/.config/hypr/hyprlock.conf
ln -sf ~/.config/omarchy/current/theme/hyprlock.conf ~/.config/hypr/hyprlock.conf

# Copy waybar supporting files if missing
if [ ! -f ~/.config/waybar/Modules ]; then
    cp ~/.local/share/omarchy/config/waybar/* ~/.config/waybar/ 2>/dev/null || true
fi

# Validation
echo ""
echo -e "${CYAN}🔍 Validating CypherRiot Theme...${NC}"
echo "--------------------------------"

if [ -L ~/.config/omarchy/current/theme ] && [ "$(basename $(readlink ~/.config/omarchy/current/theme))" = "cypherriot" ]; then
    echo -e "${GREEN}✓ CypherRiot theme is active${NC}"
else
    echo -e "${RED}❌ Theme validation failed!${NC}"
    exit 1
fi

if [ -f ~/.config/omarchy/current/background ]; then
    echo -e "${GREEN}✓ Background: $(basename $(readlink ~/.config/omarchy/current/background))${NC}"
else
    echo -e "${RED}❌ Background validation failed!${NC}"
fi

if [ -f ~/.config/waybar/config ]; then
    echo -e "${GREEN}✓ Waybar config is linked${NC}"
else
    echo -e "${RED}❌ Waybar config validation failed!${NC}"
fi

# Restart waybar with new theme
echo ""
echo -e "${CYAN}🔄 Starting waybar with CypherRiot theme...${NC}"
waybar &
sleep 3

# Check if waybar is running
if pgrep waybar > /dev/null; then
    echo -e "${GREEN}✓ Waybar started successfully with CypherRiot theme!${NC}"
else
    echo -e "${RED}❌ Waybar failed to start${NC}"
fi

# Restart background service
echo -e "${YELLOW}Restarting background service...${NC}"
pkill swaybg || true
sleep 1
swaybg -i ~/.config/omarchy/current/background -m fill &

echo ""
echo -e "${GREEN}🎉 CypherRiot Theme Applied Successfully!${NC}"
echo ""

# LUKS Boot Image Update
echo -e "${PURPLE}🔒 LUKS Boot Image Update${NC}"
echo "========================"
echo ""
echo -e "${YELLOW}Your LUKS boot screen still shows the default image.${NC}"
echo -e "${YELLOW}Would you like to update it with the OhmArchy ASCII art?${NC}"
echo ""
echo -e "${CYAN}This will:${NC}"
echo -e "${CYAN}  - Convert OhmArchy ASCII art to boot logo${NC}"
echo -e "${CYAN}  - Update Plymouth theme${NC}"
echo -e "${CYAN}  - Rebuild initramfs${NC}"
echo -e "${CYAN}  - Require reboot to see changes${NC}"
echo ""

read -p "Update LUKS boot image with OhmArchy ASCII art? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Updating LUKS boot image...${NC}"
    if [ -f ~/.local/share/omarchy/bin/generate-boot-logo.sh ]; then
        ~/.local/share/omarchy/bin/generate-boot-logo.sh
    else
        echo -e "${RED}❌ Boot logo generator not found${NC}"
    fi
else
    echo -e "${YELLOW}Skipping LUKS boot image update.${NC}"
    echo -e "${YELLOW}Run this later: ~/.local/share/omarchy/bin/generate-boot-logo.sh${NC}"
fi

echo ""
echo -e "${GREEN}🎯 FIXES APPLIED:${NC}"
echo -e "${GREEN}  ✓ CypherRiot theme forced as default${NC}"
echo -e "${GREEN}  ✓ CypherRiot waybar with all modules${NC}"
echo -e "${GREEN}  ✓ CypherRiot background (cyber.jpg)${NC}"
echo -e "${GREEN}  ✓ All theme configurations linked${NC}"
echo ""
echo -e "${BLUE}Your waybar should now show:${NC}"
echo -e "${BLUE}  - Tomato Timer (Pomodoro)${NC}"
echo -e "${BLUE}  - Mullvad VPN Status${NC}"
echo -e "${BLUE}  - CPU & Memory Monitoring${NC}"
echo -e "${BLUE}  - Microphone Control${NC}"
echo -e "${BLUE}  - CypherRiot purple/blue styling${NC}"
echo ""
echo -e "${PURPLE}If waybar still looks wrong, reboot and run this script again.${NC}"
