source /usr/share/cachyos-fish-config/cachyos-config.fish

# Override the CachyOS greeting with Arch logo but keep the system info  
function fish_greeting
    # Update Goose hints with current environment (quietly)
    ~/.local/bin/goose-update-hints --quiet 2>/dev/null

    # Show system info
    fastfetch --logo arch

    # Show current dynamic environment for Goose
    echo
    set_color cyan
    echo "🤖 Goose Auto-Detection Active:"
    set_color normal

    # Show what Goose knows
    echo "   Environment: $XDG_CURRENT_DESKTOP on "(if test -n "$WAYLAND_DISPLAY"; echo "Wayland"; else; echo "X11"; end)
    echo "   Processor: "(cat /proc/cpuinfo | grep "model name" | head -1 | cut -d":" -f2 | xargs)
end
