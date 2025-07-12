# Use dark mode for QT apps too (like kdenlive)
sudo pacman -S --noconfirm kvantum-qt5

# Install Bibata Modern Ice cursor theme and Obsidian icon theme
yay -S --noconfirm --needed bibata-cursor-theme
sudo pacman -S --noconfirm --needed obsidian-icon-theme

# Prefer dark mode everything
sudo pacman -S --noconfirm gnome-themes-extra # Adds Adwaita-dark theme
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

# Setup icon theme (Obsidian for beautiful file manager icons)
gsettings set org.gnome.desktop.interface icon-theme "Obsidian"

# Setup cursor theme
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
gsettings set org.gnome.desktop.interface cursor-size 24

# Setup default cursor theme links
mkdir -p ~/.icons/default
cp ~/.local/share/omarchy/default/icons/default/index.theme ~/.icons/default/index.theme

# Setup theme links
mkdir -p ~/.config/omarchy/themes
for f in ~/.local/share/omarchy/themes/*; do ln -s "$f" ~/.config/omarchy/themes/; done

# Set initial theme to cypherriot
mkdir -p ~/.config/omarchy/current
ln -snf ~/.config/omarchy/themes/cypherriot ~/.config/omarchy/current/theme
source ~/.local/share/omarchy/themes/cypherriot/backgrounds.sh
ln -snf ~/.config/omarchy/backgrounds/cypherriot ~/.config/omarchy/current/backgrounds
# Use the first available background (will be created by backgrounds.sh)
ln -snf ~/.config/omarchy/current/backgrounds/1-cyber.jpg ~/.config/omarchy/current/background

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

# FORCE CypherRiot theme application with validation
echo "🎨 Forcing CypherRiot theme application..."

# Validate and force theme linking
if [ ! -L ~/.config/omarchy/current/theme ] || [ "$(readlink ~/.config/omarchy/current/theme)" != "$(realpath ~/.config/omarchy/themes/cypherriot)" ]; then
    echo "⚠ Theme link broken or wrong, forcing CypherRiot..."
    rm -f ~/.config/omarchy/current/theme
    ln -snf ~/.config/omarchy/themes/cypherriot ~/.config/omarchy/current/theme
fi

# Validate and force background linking
if [ ! -L ~/.config/omarchy/current/background ] || [ ! -f ~/.config/omarchy/current/background ]; then
    echo "⚠ Background link broken, forcing CypherRiot background..."
    rm -f ~/.config/omarchy/current/background
    ln -snf ~/.config/omarchy/current/backgrounds/1-cyber.jpg ~/.config/omarchy/current/background
fi

# Validate and force waybar config linking
if [ ! -L ~/.config/waybar/config ] || [ "$(readlink ~/.config/waybar/config)" != "$(realpath ~/.config/omarchy/current/theme/config)" ]; then
    echo "⚠ Waybar config link broken, forcing CypherRiot waybar..."
    rm -f ~/.config/waybar/config
    ln -snf ~/.config/omarchy/current/theme/config ~/.config/waybar/config
fi

# Validate and force wofi styling
if [ ! -L ~/.config/wofi/style.css ] || [ "$(readlink ~/.config/wofi/style.css)" != "$(realpath ~/.config/omarchy/current/theme/wofi.css)" ]; then
    echo "⚠ Wofi style broken, forcing CypherRiot wofi..."
    mkdir -p ~/.config/wofi
    rm -f ~/.config/wofi/style.css
    ln -snf ~/.config/omarchy/current/theme/wofi.css ~/.config/wofi/style.css
fi

# Final validation
echo "🔍 Final theme validation:"
if [ -L ~/.config/omarchy/current/theme ] && [ "$(basename $(readlink ~/.config/omarchy/current/theme))" = "cypherriot" ]; then
    echo "✓ CypherRiot theme is active"
else
    echo "❌ Theme validation failed!"
    exit 1
fi

if [ -f ~/.config/omarchy/current/background ]; then
    echo "✓ Background is linked: $(basename $(readlink ~/.config/omarchy/current/background))"
else
    echo "❌ Background validation failed!"
    exit 1
fi

if [ -f ~/.config/waybar/config ]; then
    echo "✓ Waybar config is active"
else
    echo "❌ Waybar config validation failed!"
    exit 1
fi

echo "🎉 CypherRiot theme forced and validated successfully!"
