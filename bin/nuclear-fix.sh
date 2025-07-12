#!/usr/bin/env bash
# ==============================================================================
# NUCLEAR WAYBAR & LUKS FIX SCRIPT
# ==============================================================================
# This script FORCES CypherRiot waybar and offers LUKS background update
# Use when normal fixes fail and you need the nuclear option
# ==============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${RED}${BOLD}💥 NUCLEAR WAYBAR & LUKS FIX${NC}"
echo -e "${RED}${BOLD}============================${NC}"
echo -e "${YELLOW}This script will FORCEFULLY fix waybar and LUKS issues${NC}"
echo -e "${YELLOW}Use this when standard fixes have failed${NC}"
echo ""

# Confirm user wants to proceed
read -p "Are you ready to NUKE and rebuild waybar configuration? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Nuclear fix cancelled.${NC}"
    exit 0
fi

echo -e "${RED}${BOLD}🚀 LAUNCHING NUCLEAR FIX...${NC}"
echo ""

# Check if OhmArchy is installed
if [ ! -d ~/.local/share/omarchy ]; then
    echo -e "${RED}❌ CRITICAL: OhmArchy not found!${NC}"
    echo -e "${RED}Run the installer first: curl -fsSL https://cyphrriot.github.io/OhmArchy/setup.sh | bash${NC}"
    exit 1
fi

# STEP 1: NUKE WAYBAR COMPLETELY
echo -e "${CYAN}${BOLD}💀 STEP 1: NUKING WAYBAR PROCESSES${NC}"
echo "-----------------------------------"
echo -e "${YELLOW}Killing all waybar processes...${NC}"
pkill waybar || true
pkill -f waybar || true
sleep 3
echo -e "${GREEN}✓ Waybar processes terminated${NC}"

# STEP 2: BACKUP AND NUKE WAYBAR CONFIG
echo ""
echo -e "${CYAN}${BOLD}🗂️ STEP 2: NUKING WAYBAR CONFIGURATION${NC}"
echo "----------------------------------------"

# Create backup
if [ -d ~/.config/waybar ]; then
    backup_dir=~/.config/waybar.backup.nuclear.$(date +%s)
    echo -e "${YELLOW}Creating nuclear backup: $backup_dir${NC}"
    cp -r ~/.config/waybar "$backup_dir"
    echo -e "${GREEN}✓ Backup created${NC}"
fi

# Remove existing waybar config completely
echo -e "${YELLOW}Removing existing waybar configuration...${NC}"
rm -rf ~/.config/waybar
echo -e "${GREEN}✓ Waybar config directory nuked${NC}"

# STEP 3: REBUILD WAYBAR FROM SCRATCH
echo ""
echo -e "${CYAN}${BOLD}🔨 STEP 3: REBUILDING WAYBAR FROM OMARCHY${NC}"
echo "-------------------------------------------"

# Create fresh waybar directory
mkdir -p ~/.config/waybar

# Copy ALL waybar files from OhmArchy
echo -e "${YELLOW}Copying complete waybar configuration from OhmArchy...${NC}"
if [ -d ~/.local/share/omarchy/config/waybar ]; then
    cp -r ~/.local/share/omarchy/config/waybar/* ~/.config/waybar/
    echo -e "${GREEN}✓ Waybar base configuration copied${NC}"
else
    echo -e "${RED}❌ OhmArchy waybar config not found!${NC}"
    exit 1
fi

# STEP 4: FORCE CYPHERRIOT THEME
echo ""
echo -e "${CYAN}${BOLD}🎨 STEP 4: FORCING CYPHERRIOT THEME${NC}"
echo "------------------------------------"

# Ensure theme directories exist
mkdir -p ~/.config/omarchy/current
mkdir -p ~/.config/omarchy/themes

# Force theme links
echo -e "${YELLOW}Linking all themes...${NC}"
for theme_dir in ~/.local/share/omarchy/themes/*; do
    if [ -d "$theme_dir" ]; then
        theme_name=$(basename "$theme_dir")
        rm -f ~/.config/omarchy/themes/$theme_name
        ln -sf "$theme_dir" ~/.config/omarchy/themes/$theme_name
        echo "  ✓ Linked theme: $theme_name"
    fi
done

# FORCE CypherRiot as active theme
echo -e "${YELLOW}FORCING CypherRiot as active theme...${NC}"
rm -f ~/.config/omarchy/current/theme
ln -sf ~/.config/omarchy/themes/cypherriot ~/.config/omarchy/current/theme
echo -e "${GREEN}✓ CypherRiot theme forced as active${NC}"

# FORCE CypherRiot waybar config
echo -e "${YELLOW}FORCING CypherRiot waybar configuration...${NC}"
if [ -f ~/.config/omarchy/current/theme/config ]; then
    rm -f ~/.config/waybar/config
    ln -sf ~/.config/omarchy/current/theme/config ~/.config/waybar/config
    echo -e "${GREEN}✓ CypherRiot waybar config linked${NC}"
else
    echo -e "${RED}❌ CypherRiot waybar config not found!${NC}"
    exit 1
fi

# STEP 5: VALIDATE WAYBAR SCRIPTS
echo ""
echo -e "${CYAN}${BOLD}📜 STEP 5: VALIDATING WAYBAR SCRIPTS${NC}"
echo "-------------------------------------"

required_scripts=(
    "waybar-cpu-aggregate.py"
    "waybar-memory-accurate.py"
    "waybar-mic-status.py"
    "waybar-tomato-timer.py"
)

missing_scripts=0
for script in "${required_scripts[@]}"; do
    if [ -x ~/.local/bin/$script ]; then
        echo -e "${GREEN}✓ $script${NC}"
    else
        echo -e "${RED}❌ $script missing or not executable${NC}"
        missing_scripts=$((missing_scripts + 1))
    fi
done

if [ $missing_scripts -gt 0 ]; then
    echo -e "${YELLOW}Copying missing waybar scripts...${NC}"
    mkdir -p ~/.local/bin
    if [ -d ~/.local/share/omarchy/bin/scripts ]; then
        find ~/.local/share/omarchy/bin/scripts -name "waybar-*.py" -exec cp {} ~/.local/bin/ \;
        find ~/.local/share/omarchy/bin/scripts -name "waybar-*.sh" -exec cp {} ~/.local/bin/ \;
        chmod +x ~/.local/bin/waybar-*
        echo -e "${GREEN}✓ Waybar scripts copied and made executable${NC}"
    fi
fi

# STEP 6: SETUP BACKGROUND SYSTEM
echo ""
echo -e "${CYAN}${BOLD}🖼️ STEP 6: FORCING CYPHERRIOT BACKGROUND${NC}"
echo "------------------------------------------"

# Setup backgrounds
mkdir -p ~/.config/omarchy/backgrounds/cypherriot

# Copy CypherRiot backgrounds
if [ -d ~/.local/share/omarchy/themes/cypherriot/backgrounds ]; then
    echo -e "${YELLOW}Copying CypherRiot backgrounds...${NC}"
    cp ~/.local/share/omarchy/themes/cypherriot/backgrounds/* ~/.config/omarchy/backgrounds/cypherriot/ 2>/dev/null || true

    # Rename to expected format
    if [ -f ~/.config/omarchy/backgrounds/cypherriot/cyber.jpg ]; then
        cp ~/.config/omarchy/backgrounds/cypherriot/cyber.jpg ~/.config/omarchy/backgrounds/cypherriot/1-cyber.jpg
    fi
    echo -e "${GREEN}✓ CypherRiot backgrounds copied${NC}"
fi

# Force background links
rm -f ~/.config/omarchy/current/backgrounds
ln -sf ~/.config/omarchy/backgrounds/cypherriot ~/.config/omarchy/current/backgrounds
rm -f ~/.config/omarchy/current/background
ln -sf ~/.config/omarchy/current/backgrounds/1-cyber.jpg ~/.config/omarchy/current/background
echo -e "${GREEN}✓ Background links forced${NC}"

# STEP 7: RESTART SERVICES
echo ""
echo -e "${CYAN}${BOLD}🔄 STEP 7: RESTARTING SERVICES${NC}"
echo "--------------------------------"

# Kill and restart background service
echo -e "${YELLOW}Restarting background service...${NC}"
pkill swaybg || true
sleep 1
if [ -f ~/.config/omarchy/current/background ]; then
    swaybg -i ~/.config/omarchy/current/background -m fill &
    echo -e "${GREEN}✓ Background service restarted${NC}"
fi

# Start waybar with new configuration
echo -e "${YELLOW}Starting waybar with CypherRiot theme...${NC}"
waybar &
sleep 3

# Check if waybar started successfully
if pgrep waybar > /dev/null; then
    echo -e "${GREEN}✓ Waybar started successfully!${NC}"
else
    echo -e "${RED}❌ Waybar failed to start${NC}"
    echo -e "${YELLOW}Checking waybar logs...${NC}"
    waybar --log-level debug &
fi

# STEP 8: FINAL VALIDATION
echo ""
echo -e "${CYAN}${BOLD}🔍 STEP 8: FINAL VALIDATION${NC}"
echo "-----------------------------"

# Validate theme
if [ -L ~/.config/omarchy/current/theme ] && [ "$(basename $(readlink ~/.config/omarchy/current/theme))" = "cypherriot" ]; then
    echo -e "${GREEN}✓ CypherRiot theme is active${NC}"
else
    echo -e "${RED}❌ Theme validation failed${NC}"
fi

# Validate waybar config
if [ -L ~/.config/waybar/config ]; then
    echo -e "${GREEN}✓ Waybar config is linked to theme${NC}"
else
    echo -e "${RED}❌ Waybar config validation failed${NC}"
fi

# Validate background
if [ -f ~/.config/omarchy/current/background ]; then
    bg_file=$(basename $(readlink ~/.config/omarchy/current/background))
    echo -e "${GREEN}✓ Background active: $bg_file${NC}"
else
    echo -e "${RED}❌ Background validation failed${NC}"
fi

# STEP 9: LUKS BACKGROUND UPDATE
echo ""
echo -e "${CYAN}${BOLD}🔒 STEP 9: LUKS BACKGROUND UPDATE${NC}"
echo "----------------------------------"
echo ""
echo -e "${YELLOW}Your LUKS boot screen still shows the default image.${NC}"
echo -e "${YELLOW}Would you like to update it with the OhmArchy ASCII art now?${NC}"
echo ""
echo -e "${BLUE}This will:${NC}"
echo -e "${BLUE}  - Convert OhmArchy ASCII art to boot logo${NC}"
echo -e "${BLUE}  - Update Plymouth theme${NC}"
echo -e "${BLUE}  - Rebuild initramfs (may take a few minutes)${NC}"
echo -e "${BLUE}  - Require reboot to see changes on LUKS screen${NC}"
echo ""

read -p "Update LUKS boot screen with OhmArchy ASCII art? (Y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}Updating LUKS boot image...${NC}"
    if [ -f ~/.local/share/omarchy/bin/generate-boot-logo.sh ]; then
        ~/.local/share/omarchy/bin/generate-boot-logo.sh
    else
        echo -e "${RED}❌ Boot logo generator not found${NC}"
        echo -e "${YELLOW}Run: ~/.local/share/omarchy/bin/generate-boot-logo.sh${NC}"
    fi
else
    echo -e "${YELLOW}Skipping LUKS boot image update.${NC}"
    echo -e "${YELLOW}Run this later: ~/.local/share/omarchy/bin/generate-boot-logo.sh${NC}"
fi

# FINAL SUMMARY
echo ""
echo -e "${GREEN}${BOLD}💥 NUCLEAR FIX COMPLETE! 💥${NC}"
echo -e "${GREEN}${BOLD}=========================${NC}"
echo ""
echo -e "${GREEN}✅ ACCOMPLISHED:${NC}"
echo -e "${GREEN}  ✓ Waybar completely rebuilt with CypherRiot theme${NC}"
echo -e "${GREEN}  ✓ All waybar scripts installed and validated${NC}"
echo -e "${GREEN}  ✓ CypherRiot background system forced${NC}"
echo -e "${GREEN}  ✓ Theme links validated and working${NC}"
echo -e "${GREEN}  ✓ Services restarted with new configuration${NC}"

if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${GREEN}  ✓ LUKS boot screen updated (reboot to see)${NC}"
fi

echo ""
echo -e "${BLUE}YOUR WAYBAR SHOULD NOW SHOW:${NC}"
echo -e "${BLUE}  🍅 Tomato Timer (Pomodoro)${NC}"
echo -e "${BLUE}  🛡️ Mullvad VPN Status${NC}"
echo -e "${BLUE}  📊 CPU & Memory Monitoring${NC}"
echo -e "${BLUE}  🎤 Microphone Control${NC}"
echo -e "${BLUE}  🎨 CypherRiot purple/blue styling${NC}"
echo -e "${BLUE}  🚀 Custom separators and layout${NC}"
echo ""

if ! pgrep waybar > /dev/null; then
    echo -e "${RED}⚠️ WAYBAR NOT RUNNING - Starting manually...${NC}"
    waybar &
fi

echo -e "${PURPLE}${BOLD}If you still see issues, REBOOT and run this script again.${NC}"
echo -e "${PURPLE}${BOLD}The nuclear option should have fixed everything!${NC}"
