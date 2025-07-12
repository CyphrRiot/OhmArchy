#!/bin/bash

# OhmArchy hyprsunset Validation Script
# Validates blue light filter installation and functionality

# Parse command line arguments
READ_ONLY=false
HELP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --read-only|-r)
            READ_ONLY=true
            shift
            ;;
        --help|-h)
            HELP=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--read-only|-r] [--help|-h]"
            exit 1
            ;;
    esac
done

if [ "$HELP" = true ]; then
    echo "🌅 OhmArchy hyprsunset Validation Script"
    echo "========================================"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --read-only, -r    Run in read-only mode (no process manipulation)"
    echo "  --help, -h         Show this help message"
    echo ""
    echo "This script validates hyprsunset installation and functionality."
    echo "Use --read-only to check status without stopping/starting processes."
    exit 0
fi

echo "🌅 OhmArchy hyprsunset Validation Script"
echo "========================================"
if [ "$READ_ONLY" = true ]; then
    echo "Running in READ-ONLY mode (no process changes)"
fi
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

# Test 1: Check if hyprsunset is installed
print_section "Installation Check"

if command -v hyprsunset &> /dev/null; then
    HYPRSUNSET_PATH=$(command -v hyprsunset)
    print_status "PASS" "hyprsunset found at: $HYPRSUNSET_PATH"

    # Get version info
    if hyprsunset --help &> /dev/null; then
        print_status "PASS" "hyprsunset responds to commands"
    else
        print_status "WARN" "hyprsunset may have issues (help command failed)"
    fi
else
    print_status "FAIL" "hyprsunset not found in PATH"
    echo -e "${RED}CRITICAL:${NC} hyprsunset is not installed!"
    echo "Install with: yay -S hyprsunset"
    exit 1
fi

# Test 2: Check if hyprsunset is currently running
print_section "Runtime Status"

HYPRSUNSET_PID=$(pgrep hyprsunset)
if [ -n "$HYPRSUNSET_PID" ]; then
    print_status "PASS" "hyprsunset is running (PID: $HYPRSUNSET_PID)"

    # Check if running with correct temperature
    if pgrep -f "hyprsunset.*4000" > /dev/null; then
        print_status "PASS" "hyprsunset running with 4000K temperature"
    elif pgrep -f "hyprsunset.*-t" > /dev/null; then
        TEMP=$(ps aux | grep hyprsunset | grep -v grep | sed 's/.*-t \([0-9]*\).*/\1/')
        print_status "WARN" "hyprsunset running with temperature: ${TEMP}K (expected 4000K)"
    else
        print_status "WARN" "hyprsunset running but temperature unclear"
    fi
else
    print_status "FAIL" "hyprsunset is not running"
fi

# Test 3: Check Wayland environment
print_section "Environment Check"

if [ -n "$WAYLAND_DISPLAY" ]; then
    print_status "PASS" "Wayland display available: $WAYLAND_DISPLAY"
else
    print_status "FAIL" "WAYLAND_DISPLAY not set - hyprsunset requires Wayland"
fi

if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
    print_status "PASS" "Running on Hyprland: $XDG_CURRENT_DESKTOP"
else
    print_status "WARN" "Not running on Hyprland (current: $XDG_CURRENT_DESKTOP)"
fi

# Test 4: Check Hyprland configuration
print_section "Hyprland Configuration"

HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"
if [ -f "$HYPR_CONFIG" ]; then
    print_status "PASS" "Hyprland config found: $HYPR_CONFIG"

    if grep -q "exec-once.*hyprsunset" "$HYPR_CONFIG"; then
        EXEC_LINE=$(grep "exec-once.*hyprsunset" "$HYPR_CONFIG")
        print_status "PASS" "hyprsunset autostart configured: $EXEC_LINE"

        if echo "$EXEC_LINE" | grep -q "4000"; then
            print_status "PASS" "Autostart uses 4000K temperature"
        else
            print_status "WARN" "Autostart temperature may not be 4000K"
        fi
    else
        print_status "FAIL" "hyprsunset autostart not configured in Hyprland"
        echo -e "${YELLOW}Add this line to $HYPR_CONFIG:${NC}"
        echo "exec-once = hyprsunset -t 4000"
    fi
else
    print_status "FAIL" "Hyprland config not found"
fi

# Test 5: Manual start/stop test
print_section "Functionality Test"

if [ "$READ_ONLY" = true ]; then
    print_status "INFO" "Skipping functionality test (read-only mode)"
    print_status "INFO" "Run without --read-only to test start/stop functionality"
else
    # Store original PID to restore later
    ORIGINAL_PID="$HYPRSUNSET_PID"
    ORIGINAL_TEMP=""

    # Try to detect original temperature
    if [ -n "$ORIGINAL_PID" ]; then
        ORIGINAL_TEMP=$(ps aux | grep hyprsunset | grep -v grep | sed 's/.*-t \([0-9]*\).*/\1/' | head -1)
        if [[ ! "$ORIGINAL_TEMP" =~ ^[0-9]+$ ]]; then
            ORIGINAL_TEMP="4000"  # Default fallback
        fi
    fi

    print_status "INFO" "Testing functionality (will restore original state)"

    if [ -n "$HYPRSUNSET_PID" ]; then
        print_status "INFO" "Stopping current hyprsunset (temp: ${ORIGINAL_TEMP}K) for testing..."
        pkill hyprsunset
        sleep 1
    fi

    print_status "INFO" "Testing manual start..."
    hyprsunset -t 4000 &
    TEST_PID=$!
    sleep 2

    if pgrep hyprsunset > /dev/null; then
        print_status "PASS" "Manual start successful"

        # Test temperature change
        print_status "INFO" "Testing temperature change to 3000K..."
        pkill hyprsunset
        sleep 1
        hyprsunset -t 3000 &
        sleep 2

        if pgrep hyprsunset > /dev/null; then
            print_status "PASS" "Temperature change test successful"
        else
            print_status "FAIL" "Temperature change test failed"
        fi

        # Restore original temperature
        pkill hyprsunset
        sleep 1
        if [ -n "$ORIGINAL_TEMP" ]; then
            hyprsunset -t "$ORIGINAL_TEMP" &
            print_status "INFO" "Restored to original temperature (${ORIGINAL_TEMP}K)"
        else
            hyprsunset -t 4000 &
            print_status "INFO" "Restored to default temperature (4000K)"
        fi
    else
        print_status "FAIL" "Manual start failed"
        print_status "INFO" "Troubleshooting info:"
        echo "  - Wayland: $WAYLAND_DISPLAY"
        echo "  - Desktop: $XDG_CURRENT_DESKTOP"
        echo "  - hyprsunset path: $(command -v hyprsunset)"

        # Try to restore original if test failed
        if [ -n "$ORIGINAL_TEMP" ]; then
            hyprsunset -t "$ORIGINAL_TEMP" &
            print_status "INFO" "Attempted to restore original temperature"
        fi
    fi
fi

# Test 6: Check for common issues
print_section "Common Issues Check"

# Check if running in TTY instead of Wayland
if [ "$TERM" = "linux" ]; then
    print_status "WARN" "Running in TTY - hyprsunset requires Wayland session"
fi

# Check if multiple instances
INSTANCE_COUNT=$(pgrep hyprsunset | wc -l)
if [ "$INSTANCE_COUNT" -gt 1 ]; then
    print_status "WARN" "Multiple hyprsunset instances running ($INSTANCE_COUNT)"
    echo -e "${YELLOW}Consider running: pkill hyprsunset && hyprsunset -t 4000 &${NC}"
fi

# Check for conflicting programs
if pgrep redshift > /dev/null; then
    print_status "WARN" "redshift is running - may conflict with hyprsunset"
fi

if pgrep gammastep > /dev/null; then
    print_status "WARN" "gammastep is running - may conflict with hyprsunset"
fi

# Final summary
print_section "Summary"

echo -e "${CYAN}Tests completed: $TOTAL_TESTS${NC}"
echo -e "${GREEN}Tests passed: $TESTS_PASSED${NC}"
echo -e "${RED}Issues found: $ISSUES_FOUND${NC}"

if [ $ISSUES_FOUND -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 hyprsunset is working perfectly!${NC}"
    echo -e "${GREEN}Blue light filtering is active at 4000K${NC}"
    echo -e "${GREEN}Automatic startup is configured correctly${NC}"
elif [ $ISSUES_FOUND -le 2 ]; then
    echo ""
    echo -e "${YELLOW}⚠ hyprsunset has minor issues${NC}"
    echo -e "${YELLOW}Blue light filtering should work but may need attention${NC}"
else
    echo ""
    echo -e "${RED}❌ hyprsunset has significant issues${NC}"
    echo -e "${RED}Blue light filtering may not work properly${NC}"
    echo ""
    echo -e "${CYAN}Quick fixes to try:${NC}"
    echo "1. Restart hyprsunset: pkill hyprsunset && hyprsunset -t 4000 &"
    echo "2. Check Hyprland config: grep hyprsunset ~/.config/hypr/hyprland.conf"
    echo "3. Reinstall: yay -S hyprsunset"
    echo "4. Restart Hyprland session"
fi

echo ""
echo -e "${PURPLE}Manual commands:${NC}"
echo "• Start: hyprsunset -t 4000 &"
echo "• Stop: pkill hyprsunset"
echo "• Check status: pgrep hyprsunset"
echo "• Warmer (3000K): hyprsunset -t 3000 &"
echo "• Cooler (6500K): hyprsunset -t 6500 &"
echo "• Read-only check: $0 --read-only"

exit $ISSUES_FOUND
