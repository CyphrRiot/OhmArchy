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
ln -snf ~/.config/omarchy/current/backgrounds/1-Dark-Purple-Abstract.jpg ~/.config/omarchy/current/background

# Set specific app links for current theme
ln -snf ~/.config/omarchy/current/theme/hyprlock.conf ~/.config/hypr/hyprlock.conf
ln -snf ~/.config/omarchy/current/theme/wofi.css ~/.config/wofi/style.css
ln -snf ~/.config/omarchy/current/theme/neovim.lua ~/.config/nvim/lua/plugins/theme.lua
mkdir -p ~/.config/btop/themes
ln -snf ~/.config/omarchy/current/theme/btop.theme ~/.config/btop/themes/current.theme
mkdir -p ~/.config/mako
ln -snf ~/.config/omarchy/current/theme/mako.ini ~/.config/mako/config
# Enhanced theme validation and linking
theme_config="~/.config/omarchy/current/theme/config"
waybar_config="~/.config/waybar/config"
default_config="~/.config/waybar/config.default"

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
