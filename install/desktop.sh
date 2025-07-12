# Install packages with better error handling
packages=(
    "brightnessctl playerctl pamixer pavucontrol wireplumber"
    "fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool"
    "wl-clip-persist"
    "thunar sushi ffmpegthumbnailer gnome-calculator"
    "hyprsunset gnome-keyring"
    "brave-bin mpv evince imv"
    "mullvad-vpn-bin"
    "nwg-drawer swaync"
)

for package_group in "${packages[@]}"; do
    echo "Installing: $package_group"
    if yay -S --noconfirm --needed $package_group; then
        echo "✓ Success: $package_group"
    else
        echo "⚠ Failed: $package_group (continuing...)"
    fi
done
