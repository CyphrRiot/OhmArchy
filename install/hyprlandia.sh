# Define critical Hyprland packages that must succeed
critical_packages=(
    "hyprland"
    "waybar"
    "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal-gtk"
    "polkit-gnome"
    "wofi"
    "mako"
    "swaybg"
    "hyprlock"
    "hypridle"
    "grim"
    "slurp"
    "python"
    "python-psutil"
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

# Install essential Hyprland utilities
echo "Installing essential Hyprland utilities..."
yay -S --noconfirm --needed \
    hyprshot \
    hyprpicker \
    hyprland-qtutils

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
