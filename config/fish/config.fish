# Source CachyOS fish config if available (optional for non-CachyOS systems)
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# Override the CachyOS greeting with Arch logo but keep the system info
function fish_greeting
    # Update Goose hints with current environment (quietly) - only if available
    if command -v goose-update-hints >/dev/null 2>&1
        ~/.local/bin/goose-update-hints --quiet 2>/dev/null
    end

    # Show system info with fallback if fastfetch not available
    if command -v fastfetch >/dev/null 2>&1
        fastfetch --logo arch
    else
        echo "Welcome to OhmArchy!"
        echo "System: $(uname -s) $(uname -r)"
    end

    # Show current dynamic environment for Goose - only if goose is available
    if command -v goose >/dev/null 2>&1
        echo
        set_color cyan
        echo "🤖 Goose Auto-Detection Active:"
        set_color normal

        # Show what Goose knows
        echo "   Environment: $XDG_CURRENT_DESKTOP on "(if test -n "$WAYLAND_DISPLAY"; echo "Wayland"; else; echo "X11"; end)
        echo "   Processor: "(cat /proc/cpuinfo | grep "model name" | head -1 | cut -d":" -f2 | xargs)
    end
end
