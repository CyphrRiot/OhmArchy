# Define critical Hyprland packages that must succeed
critical_packages=(
    "hyprland"
    "waybar"
    "xdg-desktop-portal-hyprland"
    "polkit-gnome"
    "wofi"
)

# Define optional Hyprland packages that can fail
optional_packages=(
    "hyprshot hyprpicker hyprlock hypridle"
    "hyprland-qtutils"
    "mako swaybg"
    "xdg-desktop-portal-gtk"
    "grim slurp"
)

# Install critical packages - failure stops installation
echo "Installing critical Hyprland packages..."
for package_group in "${critical_packages[@]}"; do
    echo "Installing: $package_group"
    if yay -S --noconfirm --needed "$package_group"; then
        echo "✓ Success: $package_group"
    else
        echo "Error: Failed to install critical Hyprland package: $package_group"
        echo "Hyprland desktop environment will not work without this package."
        exit 1
    fi
done

# Install optional packages - failure continues with warning
echo "Installing optional Hyprland packages..."
for package_group in "${optional_packages[@]}"; do
    echo "Installing: $package_group"
    if yay -S --noconfirm --needed "$package_group"; then
        echo "✓ Success: $package_group"
    else
        echo "⚠ Failed: $package_group (optional - continuing...)"
    fi
done

# Validate critical components are actually available
echo "Validating Hyprland installation..."
if ! command -v Hyprland &>/dev/null; then
    echo "Error: Hyprland command not found after installation"
    exit 1
fi
if ! command -v waybar &>/dev/null; then
    echo "Error: waybar command not found after installation"
    exit 1
fi
echo "✓ Critical Hyprland components validated"

# Start Hyprland on first session - bash only (fish config handled in 3-terminal.sh)
echo "[[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]] && exec Hyprland" >~/.bash_profile
