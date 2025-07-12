#!/usr/bin/env bash
# ==============================================================================
# OhmArchy Installation Validation Script
# ==============================================================================
# Validates that critical applications and components are properly installed
# ==============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

# Check function
check_item() {
    local description="$1"
    local check_command="$2"
    local is_critical="${3:-false}"

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    if eval "$check_command" &>/dev/null; then
        echo -e "${GREEN}✓${NC} $description"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        if [ "$is_critical" = "true" ]; then
            echo -e "${RED}✗${NC} $description ${RED}(CRITICAL)${NC}"
        else
            echo -e "${YELLOW}⚠${NC} $description ${YELLOW}(Optional)${NC}"
        fi
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
        return 1
    fi
}

# Check package installation
check_package() {
    local package_name="$1"
    local is_critical="${2:-false}"
    check_item "Package: $package_name" "pacman -Q $package_name" "$is_critical"
}

# Check binary availability
check_binary() {
    local binary_name="$1"
    local is_critical="${2:-false}"
    check_item "Binary: $binary_name" "command -v $binary_name" "$is_critical"
}

# Check desktop file existence
check_desktop_file() {
    local app_name="$1"
    local is_critical="${2:-false}"
    check_item "Desktop: $app_name" "find ~/.local/share/applications /usr/share/applications -name '*$app_name*.desktop' -type f" "$is_critical"
}

# Check waybar script
check_waybar_script() {
    local script_name="$1"
    check_item "Waybar Script: $script_name" "test -x ~/.local/bin/$script_name" "true"
}

echo -e "${BLUE}🔍 OhmArchy Installation Validation${NC}"
echo -e "${BLUE}====================================${NC}"
echo ""

# Critical System Components
echo -e "${CYAN}📦 Critical System Packages${NC}"
echo "----------------------------"
check_package "hyprland" "true"
check_package "waybar" "true"
check_package "wofi" "true"
check_package "kitty" "true"
check_package "thunar" "true"
check_package "brave-bin" "true"
check_package "fish" "true"

echo ""

# Critical Binaries
echo -e "${CYAN}⚙️ Critical Application Binaries${NC}"
echo "--------------------------------"
check_binary "Hyprland" "true"
check_binary "waybar" "true"
check_binary "wofi" "true"
check_binary "kitty" "true"
check_binary "Thunar" "true"
check_binary "brave" "true"
check_binary "fish" "true"

echo ""

# Waybar Scripts
echo -e "${CYAN}📜 Waybar Scripts${NC}"
echo "-----------------"
check_waybar_script "waybar-cpu-aggregate.py"
check_waybar_script "waybar-memory-accurate.py"
check_waybar_script "waybar-mic-status.py"
check_waybar_script "waybar-tomato-timer.py"

echo ""

# Optional Applications
echo -e "${CYAN}📱 Optional Applications${NC}"
echo "------------------------"
check_package "feather-wallet-bin" "false"
check_binary "feather-wallet" "false"
check_package "signal-desktop" "false"
check_binary "signal-desktop" "false"
check_package "mullvad-vpn-bin" "false"
check_binary "mullvad" "false"

echo ""

# Desktop Files
echo -e "${CYAN}🖥️ Desktop Integration${NC}"
echo "----------------------"
check_desktop_file "thunar" "true"
check_desktop_file "brave" "true"
check_desktop_file "feather" "false"
check_desktop_file "proton" "false"
check_desktop_file "signal" "false"

echo ""

# Filesystem Support
echo -e "${CYAN}💾 Filesystem Support${NC}"
echo "--------------------"
check_package "ntfs-3g" "true"
check_package "exfatprogs" "true"
check_package "gvfs" "true"
check_package "udisks2" "true"

echo ""

# Theme System
echo -e "${CYAN}🎨 Theme System${NC}"
echo "---------------"
check_item "Current Theme Link" "test -L ~/.config/omarchy/current/theme" "true"
check_item "Current Background Link" "test -L ~/.config/omarchy/current/background" "true"
check_item "Waybar Config" "test -f ~/.config/waybar/config" "true"
check_item "Fish Config" "test -f ~/.config/fish/config.fish" "true"

echo ""

# Configuration Files
echo -e "${CYAN}⚙️ Configuration Files${NC}"
echo "----------------------"
check_item "Hyprland Config" "test -f ~/.config/hypr/hyprland.conf" "true"
check_item "Kitty Config" "test -f ~/.config/kitty/kitty.conf" "true"
check_item "Wofi Config" "test -f ~/.config/wofi/config" "false"

echo ""

# Key Bindings Test
echo -e "${CYAN}⌨️ Key Binding Configuration${NC}"
echo "----------------------------"
check_item "SUPER+F binding (Thunar)" "grep -q 'bind.*\$mod.*F.*\$fileManager' ~/.config/hypr/hyprland.conf" "true"
check_item "SUPER+B binding (Brave)" "grep -q 'bind.*\$mod.*B.*\$browser' ~/.config/hypr/hyprland.conf" "true"
check_item "SUPER+D binding (Wofi)" "grep -q 'bind.*\$mod.*D.*wofi' ~/.config/hypr/hyprland.conf" "true"
check_item "SUPER+SPACE binding (Wofi)" "grep -q 'bind.*\$mod.*space.*wofi' ~/.config/hypr/hyprland.conf" "true"
check_item "Theme Switch binding" "grep -q 'bind.*\$mod.*CTRL.*SHIFT.*SPACE.*omarchy-theme-next' ~/.config/hypr/hyprland.conf" "true"

echo ""

# Application Variables
echo -e "${CYAN}🔧 Application Variables${NC}"
echo "------------------------"
check_item "File Manager = Thunar" "grep -q '\$fileManager = Thunar' ~/.config/hypr/hyprland.conf" "true"
check_item "Browser = brave" "grep -q '\$browser = brave' ~/.config/hypr/hyprland.conf" "true"
check_item "Terminal = kitty" "grep -q '\$terminal = kitty' ~/.config/hypr/hyprland.conf" "true"

echo ""

# Plymouth Theme
echo -e "${CYAN}🎭 Plymouth Boot Theme${NC}"
echo "----------------------"
check_item "Plymouth Package" "pacman -Q plymouth" "false"
check_item "Plymouth Theme Dir" "test -d /usr/share/plymouth/themes/omarchy" "false"
check_item "Plymouth Theme Active" "test -f /usr/share/plymouth/themes/omarchy/omarchy.plymouth" "false"

echo ""

# Summary
echo -e "${BLUE}📊 Validation Summary${NC}"
echo -e "${BLUE}=====================${NC}"
echo -e "Total Checks: ${CYAN}$TOTAL_CHECKS${NC}"
echo -e "Passed: ${GREEN}$PASSED_CHECKS${NC}"
echo -e "Failed: ${RED}$FAILED_CHECKS${NC}"

if [ $FAILED_CHECKS -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 All checks passed! OhmArchy installation is complete and functional.${NC}"
    exit 0
elif [ $FAILED_CHECKS -le 5 ]; then
    echo ""
    echo -e "${YELLOW}⚠ Minor issues detected. Some optional components may not be working.${NC}"
    echo -e "${YELLOW}Consider running the installation again or check specific failed items.${NC}"
    exit 1
else
    echo ""
    echo -e "${RED}❌ Major issues detected! Multiple critical components are missing.${NC}"
    echo -e "${RED}Re-run the OhmArchy installation to fix these issues:${NC}"
    echo -e "${RED}  curl -fsSL https://cyphrriot.github.io/OhmArchy/setup.sh | bash${NC}"
    exit 2
fi
