#!/bin/bash

# OhmArchy Cursor Theme Validation Script
# Validates Bibata-Modern-Ice cursor installation and configuration

echo "🖱️ OhmArchy Cursor Theme Validation Script"
echo "=========================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Status tracking
ISSUES_FOUND=0
TESTS_PASSED=0
TOTAL_TESTS=0

print_status() {
    local status=$1
    local message=$2
    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}✓${NC} $message"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    elif [ "$status" = "FAIL" ]; then
        echo -e "${RED}✗${NC} $message"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    elif [ "$status" = "WARN" ]; then
        echo -e "${YELLOW}⚠${NC} $message"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    elif [ "$status" = "INFO" ]; then
        echo -e "${BLUE}ℹ${NC} $message"
    fi
}

print_section() {
    echo ""
    echo -e "${PURPLE}## $1${NC}"
    echo "----------------------------------------"
}

# Test 1: Check if cursor theme package is installed
print_section "Package Installation"

if pacman -Q bibata-cursor-theme &> /dev/null; then
    PACKAGE_VERSION=$(pacman -Q bibata-cursor-theme | awk '{print $2}')
    print_status "PASS" "bibata-cursor-theme package installed (version: $PACKAGE_VERSION)"
else
    print_status "FAIL" "bibata-cursor-theme package not installed"
    echo -e "${RED}CRITICAL:${NC} Install with: yay -S bibata-cursor-theme"
fi

# Test 2: Check cursor theme files exist
print_section "Cursor Theme Files"

CURSOR_LOCATIONS=(
    "/usr/share/icons/Bibata-Modern-Ice"
    "$HOME/.local/share/icons/Bibata-Modern-Ice"
    "$HOME/.icons/Bibata-Modern-Ice"
)

CURSOR_FOUND=false
for location in "${CURSOR_LOCATIONS[@]}"; do
    if [ -d "$location" ]; then
        print_status "PASS" "Cursor theme found at: $location"
        CURSOR_FOUND=true

        # Check for essential cursor files
        if [ -f "$location/cursors/default" ] || [ -f "$location/cursors/left_ptr" ]; then
            print_status "PASS" "Essential cursor files present"
        else
            print_status "WARN" "Cursor directory exists but may be incomplete"
        fi

        # Check index.theme file
        if [ -f "$location/index.theme" ]; then
            print_status "PASS" "index.theme file present"
        else
            print_status "WARN" "index.theme file missing"
        fi
        break
    fi
done

if [ "$CURSOR_FOUND" = false ]; then
    print_status "FAIL" "Bibata-Modern-Ice cursor theme not found in any standard location"
fi

# Test 3: Check default cursor theme links
print_section "Default Cursor Configuration"

if [ -f "$HOME/.icons/default/index.theme" ]; then
    print_status "PASS" "Default cursor theme index file exists"

    # Check if it points to Bibata-Modern-Ice
    if grep -q "Bibata-Modern-Ice" "$HOME/.icons/default/index.theme"; then
        print_status "PASS" "Default cursor points to Bibata-Modern-Ice"
    else
        print_status "WARN" "Default cursor points to different theme"
        grep "Inherits=" "$HOME/.icons/default/index.theme" | head -1
    fi
else
    print_status "FAIL" "Default cursor theme index file missing"
    echo -e "${YELLOW}Should be at: $HOME/.icons/default/index.theme${NC}"
fi

# Test 4: Check environment variables
print_section "Environment Variables"

if [ -n "$XCURSOR_THEME" ]; then
    if [ "$XCURSOR_THEME" = "Bibata-Modern-Ice" ]; then
        print_status "PASS" "XCURSOR_THEME set correctly: $XCURSOR_THEME"
    else
        print_status "WARN" "XCURSOR_THEME set to different theme: $XCURSOR_THEME"
    fi
else
    print_status "WARN" "XCURSOR_THEME environment variable not set"
fi

if [ -n "$HYPRCURSOR_THEME" ]; then
    if [ "$HYPRCURSOR_THEME" = "Bibata-Modern-Ice" ]; then
        print_status "PASS" "HYPRCURSOR_THEME set correctly: $HYPRCURSOR_THEME"
    else
        print_status "WARN" "HYPRCURSOR_THEME set to different theme: $HYPRCURSOR_THEME"
    fi
else
    print_status "WARN" "HYPRCURSOR_THEME environment variable not set"
fi

if [ -n "$XCURSOR_SIZE" ]; then
    print_status "PASS" "XCURSOR_SIZE set to: $XCURSOR_SIZE"
else
    print_status "WARN" "XCURSOR_SIZE environment variable not set"
fi

if [ -n "$HYPRCURSOR_SIZE" ]; then
    print_status "PASS" "HYPRCURSOR_SIZE set to: $HYPRCURSOR_SIZE"
else
    print_status "WARN" "HYPRCURSOR_SIZE environment variable not set"
fi

# Test 5: Check Hyprland configuration
print_section "Hyprland Configuration"

HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"
if [ -f "$HYPR_CONFIG" ]; then
    print_status "PASS" "Hyprland config found"

    if grep -q "env.*XCURSOR_THEME.*Bibata-Modern-Ice" "$HYPR_CONFIG"; then
        print_status "PASS" "XCURSOR_THEME configured in Hyprland"
    else
        print_status "FAIL" "XCURSOR_THEME not configured in Hyprland"
        echo -e "${YELLOW}Add: env = XCURSOR_THEME,Bibata-Modern-Ice${NC}"
    fi

    if grep -q "env.*HYPRCURSOR_THEME.*Bibata-Modern-Ice" "$HYPR_CONFIG"; then
        print_status "PASS" "HYPRCURSOR_THEME configured in Hyprland"
    else
        print_status "FAIL" "HYPRCURSOR_THEME not configured in Hyprland"
        echo -e "${YELLOW}Add: env = HYPRCURSOR_THEME,Bibata-Modern-Ice${NC}"
    fi

    if grep -q "env.*XCURSOR_SIZE" "$HYPR_CONFIG"; then
        CURSOR_SIZE=$(grep "env.*XCURSOR_SIZE" "$HYPR_CONFIG" | head -1 | cut -d',' -f2)
        print_status "PASS" "XCURSOR_SIZE configured: $CURSOR_SIZE"
    else
        print_status "WARN" "XCURSOR_SIZE not configured in Hyprland"
    fi
else
    print_status "FAIL" "Hyprland config not found"
fi

# Test 6: Check gsettings configuration
print_section "GTK/GNOME Settings"

if command -v gsettings >/dev/null 2>&1; then
    print_status "PASS" "gsettings available"

    CURRENT_CURSOR=$(gsettings get org.gnome.desktop.interface cursor-theme 2>/dev/null | tr -d "'")
    if [ "$CURRENT_CURSOR" = "Bibata-Modern-Ice" ]; then
        print_status "PASS" "GTK cursor theme set correctly: $CURRENT_CURSOR"
    elif [ -n "$CURRENT_CURSOR" ]; then
        print_status "WARN" "GTK cursor theme set to different theme: $CURRENT_CURSOR"
    else
        print_status "WARN" "GTK cursor theme not set"
    fi

    CURRENT_SIZE=$(gsettings get org.gnome.desktop.interface cursor-size 2>/dev/null)
    if [ -n "$CURRENT_SIZE" ] && [ "$CURRENT_SIZE" != "0" ]; then
        print_status "PASS" "GTK cursor size set: $CURRENT_SIZE"
    else
        print_status "WARN" "GTK cursor size not set or is 0"
    fi
else
    print_status "WARN" "gsettings not available (GTK apps may use fallback cursor)"
fi

# Test 7: Check session type
print_section "Session Environment"

if [ -n "$WAYLAND_DISPLAY" ]; then
    print_status "PASS" "Running on Wayland: $WAYLAND_DISPLAY"

    if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
        print_status "PASS" "Running on Hyprland"
    else
        print_status "WARN" "Not running on Hyprland (current: $XDG_CURRENT_DESKTOP)"
    fi
else
    print_status "WARN" "Not running on Wayland - cursor theme behavior may differ"

    if [ -n "$DISPLAY" ]; then
        print_status "INFO" "Running on X11: $DISPLAY"
    fi
fi

# Test 8: Check for conflicting cursor themes
print_section "Potential Conflicts"

OTHER_CURSORS=$(find /usr/share/icons ~/.local/share/icons ~/.icons -maxdepth 1 -type d -name "*cursor*" -o -name "*Cursor*" 2>/dev/null | grep -v Bibata-Modern-Ice | head -5)
if [ -n "$OTHER_CURSORS" ]; then
    print_status "INFO" "Other cursor themes found (may cause conflicts):"
    echo "$OTHER_CURSORS" | while read -r theme; do
        echo "  - $(basename "$theme")"
    done
else
    print_status "PASS" "No conflicting cursor themes detected"
fi

# Final summary
print_section "Summary"

echo -e "${CYAN}Tests completed: $TOTAL_TESTS${NC}"
echo -e "${GREEN}Tests passed: $TESTS_PASSED${NC}"
echo -e "${RED}Issues found: $ISSUES_FOUND${NC}"

if [ $ISSUES_FOUND -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 Cursor theme is working perfectly!${NC}"
    echo -e "${GREEN}Bibata-Modern-Ice should be active in all applications${NC}"
elif [ $ISSUES_FOUND -le 3 ]; then
    echo ""
    echo -e "${YELLOW}⚠ Cursor theme has minor issues${NC}"
    echo -e "${YELLOW}Cursors should mostly work but may need attention${NC}"
else
    echo ""
    echo -e "${RED}❌ Cursor theme has significant issues${NC}"
    echo -e "${RED}Cursors may not display correctly${NC}"
    echo ""
    echo -e "${CYAN}Quick fixes to try:${NC}"
    echo "1. Install theme: yay -S bibata-cursor-theme"
    echo "2. Set environment vars in Hyprland config"
    echo "3. Configure GTK: gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'"
    echo "4. Create default links: mkdir -p ~/.icons/default && echo '[Icon Theme]\nInherits=Bibata-Modern-Ice' > ~/.icons/default/index.theme"
    echo "5. Restart Hyprland session"
fi

echo ""
echo -e "${PURPLE}Manual cursor commands:${NC}"
echo "• Set GTK cursor: gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'"
echo "• Set cursor size: gsettings set org.gnome.desktop.interface cursor-size 24"
echo "• List available cursors: find /usr/share/icons -name cursors -type d"
echo "• Test cursor: XCURSOR_THEME=Bibata-Modern-Ice XCURSOR_SIZE=24 your_app"

exit $ISSUES_FOUND
