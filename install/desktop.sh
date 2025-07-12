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

# Define critical packages that must succeed
critical_packages=(
    "brightnessctl playerctl pamixer pavucontrol wireplumber"
    "thunar"
    "sushi ffmpegthumbnailer gnome-calculator"
    "hyprsunset gnome-keyring"
    "nwg-drawer swaync"
    "brave-bin"
    "mpv"
    "evince"
    "imv"
    "mullvad-vpn-bin"
)

# Define optional packages that can fail
optional_packages=(
    "fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool"
    "wl-clip-persist"
)

# Install critical packages - failure stops installation
echo "Installing critical desktop packages..."
for package_group in "${critical_packages[@]}"; do
    echo "Installing: $package_group"
    if yay -S --noconfirm --needed "$package_group"; then
        echo "✓ Success: $package_group"
    else
        echo "Error: Failed to install critical package group: $package_group"
        exit 1
    fi
done

# Install optional packages - failure continues with warning
echo "Installing optional desktop packages..."
for package_group in "${optional_packages[@]}"; do
    echo "Installing: $package_group"
    if yay -S --noconfirm --needed "$package_group"; then
        echo "✓ Success: $package_group"
    else
        echo "⚠ Failed: $package_group (optional - continuing...)"
    fi
done
