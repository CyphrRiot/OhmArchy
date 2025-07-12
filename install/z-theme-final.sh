# Use dark mode for QT apps too (like kdenlive)
sudo pacman -S --noconfirm kvantum-qt5

# Install Bibata Modern Ice cursor theme and Obsidian icon theme
echo "Installing cursor and icon themes..."
if ! yay -S --noconfirm --needed bibata-cursor-theme; then
    echo "❌ CRITICAL: Failed to install bibata-cursor-theme"
    exit 1
fi

# Verify cursor theme installation
if [ ! -d "/usr/share/icons/Bibata-Modern-Ice" ] && [ ! -d "$HOME/.local/share/icons/Bibata-Modern-Ice" ]; then
    echo "❌ CRITICAL: Bibata-Modern-Ice cursor theme not found after installation"
    exit 1
fi
echo "✓ Bibata cursor theme installed successfully"

sudo pacman -S --noconfirm --needed obsidian-icon-theme

# Prefer dark mode everything
sudo pacman -S --noconfirm gnome-themes-extra # Adds Adwaita-dark theme
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

# Setup icon theme (Obsidian for beautiful file manager icons)
gsettings set org.gnome.desktop.interface icon-theme "Obsidian"

# Setup cursor theme with validation
echo "Configuring cursor theme..."
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
    gsettings set org.gnome.desktop.interface cursor-size 24
    echo "✓ Cursor theme configured via gsettings"
else
    echo "⚠ gsettings not available, cursor theme will be handled by Hyprland env vars"
fi

# Setup default cursor theme links
mkdir -p ~/.icons/default
if [ -f ~/.local/share/omarchy/default/icons/default/index.theme ]; then
    cp ~/.local/share/omarchy/default/icons/default/index.theme ~/.icons/default/index.theme
    echo "✓ Default cursor theme links created"
else
    echo "⚠ Default cursor theme index file not found"
fi

# Verify cursor theme is accessible
if [ -d "/usr/share/icons/Bibata-Modern-Ice" ] || [ -d "$HOME/.local/share/icons/Bibata-Modern-Ice" ] || [ -d "$HOME/.icons/Bibata-Modern-Ice" ]; then
    echo "✓ Bibata-Modern-Ice cursor theme is accessible"
else
    echo "❌ CRITICAL: Bibata-Modern-Ice cursor theme not accessible"
    exit 1
fi

# Setup theme links
mkdir -p ~/.config/omarchy/themes
for f in ~/.local/share/omarchy/themes/*; do ln -s "$f" ~/.config/omarchy/themes/; done

# Set initial theme to cypherriot
mkdir -p ~/.config/omarchy/current
ln -snf ~/.config/omarchy/themes/cypherriot ~/.config/omarchy/current/theme
source ~/.local/share/omarchy/themes/cypherriot/backgrounds.sh
ln -snf ~/.config/omarchy/backgrounds/cypherriot ~/.config/omarchy/current/backgrounds
# Use the first available background (will be created by backgrounds.sh)
ln -snf ~/.config/omarchy/current/backgrounds/1-blue_night_moon_over_lake.jpg ~/.config/omarchy/current/background

# Set specific app links for current theme
ln -snf ~/.config/omarchy/current/theme/hyprlock.conf ~/.config/hypr/hyprlock.conf
ln -snf ~/.config/omarchy/current/theme/wofi.css ~/.config/wofi/style.css
ln -snf ~/.config/omarchy/current/theme/neovim.lua ~/.config/nvim/lua/plugins/theme.lua
mkdir -p ~/.config/btop/themes
ln -snf ~/.config/omarchy/current/theme/btop.theme ~/.config/btop/themes/current.theme
mkdir -p ~/.config/mako
ln -snf ~/.config/omarchy/current/theme/mako.ini ~/.config/mako/config
# Enhanced theme validation and linking
theme_config="$HOME/.config/omarchy/current/theme/config"
waybar_config="$HOME/.config/waybar/config"
default_config="$HOME/.config/waybar/config.default"

# Backup original waybar config if it exists and isn't already a backup
if [ -f "$waybar_config" ] && [ ! -f "$default_config" ]; then
    cp "$waybar_config" "$default_config"
    echo "✓ Backed up original waybar config"
fi

# Link theme-specific config or restore default
if [ -f "$theme_config" ]; then
    ln -snf "$theme_config" "$waybar_config"
    echo "✓ Theme waybar config linked: $(basename $(readlink $theme_config))"
elif [ -f "$default_config" ]; then
    ln -snf "$default_config" "$waybar_config"
    echo "✓ Default waybar config restored"
else
    echo "⚠ No waybar config available (theme or default)"
fi

# FINAL BULLETPROOF THEME APPLICATION - MUST BE LAST STEP
echo "🎨 FINAL: Forcing CypherRiot theme as LAST installation step..."

# Kill any running waybar to prevent conflicts
pkill waybar || true
sleep 2

# FORCE CypherRiot theme linking with absolute paths
echo "Forcing CypherRiot theme links..."
rm -f ~/.config/omarchy/current/theme
ln -snf ~/.config/omarchy/themes/cypherriot ~/.config/omarchy/current/theme

# FORCE background system
echo "Forcing CypherRiot background system..."
rm -f ~/.config/omarchy/current/backgrounds
ln -snf ~/.config/omarchy/backgrounds/cypherriot ~/.config/omarchy/current/backgrounds
rm -f ~/.config/omarchy/current/background
ln -snf ~/.config/omarchy/current/backgrounds/1-blue_night_moon_over_lake.jpg ~/.config/omarchy/current/background

# FORCE waybar config - MOST CRITICAL
echo "FORCING CypherRiot waybar config..."
rm -f ~/.config/waybar/config
ln -snf ~/.config/omarchy/current/theme/config ~/.config/waybar/config

# FORCE all other theme configs
echo "Forcing all theme configurations..."
mkdir -p ~/.config/wofi
rm -f ~/.config/wofi/style.css
ln -snf ~/.config/omarchy/current/theme/wofi.css ~/.config/wofi/style.css

rm -f ~/.config/hypr/hyprlock.conf
ln -snf ~/.config/omarchy/current/theme/hyprlock.conf ~/.config/hypr/hyprlock.conf

mkdir -p ~/.config/mako
rm -f ~/.config/mako/config
ln -snf ~/.config/omarchy/current/theme/mako.ini ~/.config/mako/config

# Restart background service with CypherRiot background
echo "Restarting background service..."
pkill swaybg || true
sleep 1
swaybg -i ~/.config/omarchy/current/background -m fill &

# Start waybar with CypherRiot theme
echo "Starting waybar with CypherRiot theme..."
waybar &
sleep 3

# CRITICAL VALIDATION - INSTALLATION FAILS IF THIS FAILS
echo "🔍 CRITICAL VALIDATION:"
if [ ! -L ~/.config/omarchy/current/theme ] || [ "$(basename $(readlink ~/.config/omarchy/current/theme))" != "cypherriot" ]; then
    echo "❌ INSTALLATION FAILED: CypherRiot theme not active!"
    exit 1
fi

if [ ! -f ~/.config/omarchy/current/background ]; then
    echo "❌ INSTALLATION FAILED: Background not linked!"
    exit 1
fi

if [ ! -L ~/.config/waybar/config ]; then
    echo "❌ INSTALLATION FAILED: Waybar config not linked!"
    exit 1
fi

if ! pgrep waybar > /dev/null; then
    echo "❌ INSTALLATION FAILED: Waybar not running!"
    exit 1
fi

# Validate and start hyprsunset for blue light filtering
echo "Validating blue light filter (hyprsunset)..."

# First check if hyprsunset is installed
if ! command -v hyprsunset &> /dev/null; then
    echo "❌ CRITICAL: hyprsunset not found in PATH!"
    echo "Installing hyprsunset..."
    if yay -S --noconfirm --needed hyprsunset; then
        echo "✓ hyprsunset installed successfully"
    else
        echo "❌ INSTALLATION FAILED: Could not install hyprsunset!"
        exit 1
    fi
fi

# Check if hyprsunset is already running
if pgrep hyprsunset > /dev/null; then
    echo "✓ hyprsunset already running"
    # Verify it's running with correct temperature
    if pgrep -f "hyprsunset.*4500" > /dev/null; then
        echo "✓ hyprsunset running with correct temperature (4500K)"
    else
        echo "⚠ hyprsunset running but may not have correct temperature"
        echo "Restarting hyprsunset with 4500K temperature..."
        pkill hyprsunset
        sleep 1
    fi
fi

# Start hyprsunset if not running or if we need to restart
if ! pgrep hyprsunset > /dev/null; then
    echo "Starting hyprsunset for blue light filtering at 4500K..."
    hyprsunset -t 4500 &
    sleep 3

    # Verify it started successfully
    if pgrep hyprsunset > /dev/null; then
        echo "✓ hyprsunset started successfully"

        # Double-check with temperature verification
        if pgrep -f "hyprsunset.*4500" > /dev/null; then
            echo "✓ hyprsunset confirmed running with 4500K temperature"
        else
            echo "⚠ hyprsunset started but temperature verification failed"
        fi
    else
        echo "❌ CRITICAL: hyprsunset failed to start!"
        echo "Troubleshooting information:"
        echo "  - Command exists: $(command -v hyprsunset)"
        echo "  - Wayland display: $WAYLAND_DISPLAY"
        echo "  - XDG session: $XDG_CURRENT_DESKTOP"
        echo "Attempting alternative start method..."

        # Try alternative start method
        nohup hyprsunset -t 4500 > /dev/null 2>&1 &
        sleep 2

        if pgrep hyprsunset > /dev/null; then
            echo "✓ hyprsunset started with alternative method"
        else
            echo "❌ INSTALLATION FAILED: hyprsunset cannot start!"
            echo "Blue light filtering will not work automatically."
            echo "Manual start: run 'hyprsunset -t 4500' after login"
            exit 1
        fi
    fi
fi

echo "✅ CypherRiot theme SUCCESSFULLY applied and validated!"
echo "✅ Installation complete with working CypherRiot theme!"
echo "✅ Blue light filter active (4500K temperature)"
echo "✅ hyprsunset will auto-start on login via Hyprland config"
