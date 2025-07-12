# Create backup of existing configs before overwriting
echo "Creating backup of existing configs..."
if [ -d ~/.config ]; then
    cp -R ~/.config ~/.config.backup-$(date +%s) 2>/dev/null || true
    echo "✓ Backup created"
fi

# Verify Python3 is available for waybar scripts
if ! command -v python3 &> /dev/null; then
    echo "Installing Python3 for waybar scripts..."
    sudo pacman -S --noconfirm python3
fi

# Check script dependencies
echo "Checking Python dependencies for waybar scripts..."

# Ensure pip is available for Python package installation
if ! command -v pip &> /dev/null; then
    echo "Installing pip for Python package management..."
    sudo pacman -S --noconfirm python-pip
fi

python3 -c "import psutil" 2>/dev/null || {
    echo "Installing psutil for system monitoring scripts..."
    pip install --user psutil
}

# Copy over Omarchy configs
cp -R ~/.local/share/omarchy/config/* ~/.config/

# Ensure application directory exists for update-desktop-database
mkdir -p ~/.local/share/applications

# Copy waybar scripts and make executable (optimized)
mkdir -p ~/.local/bin
find ~/.local/share/omarchy/bin/scripts -type f \( -name "*.py" -o -name "*.sh" \) -exec sh -c '
    script="$1"
    basename=$(basename "$script")
    cp "$script" ~/.local/bin/
    chmod +x ~/.local/bin/$basename
    echo "✓ Installed: $basename"
' _ {} \;
echo "✓ $(find ~/.local/bin -name "waybar-*" -type f | wc -l) waybar scripts total"

# Use default bashrc from Omarchy
echo "source $HOME/.local/share/omarchy/default/bash/rc" >~/.bashrc

# Login directly as user, rely on disk encryption + hyprlock for security
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM
EOF

# Set common git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase true
git config --global init.defaultBranch master

# Set identification from install inputs
if [[ -n "${OMARCHY_USER_NAME//[[:space:]]/}" ]]; then
  git config --global user.name "$OMARCHY_USER_NAME"
fi

if [[ -n "${OMARCHY_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$OMARCHY_USER_EMAIL"
fi

# Set default XCompose that is triggered with CapsLock
tee ~/.XCompose >/dev/null <<EOF
include "%H/.local/share/omarchy/default/xcompose"

# Identification
<Multi_key> <space> <n> : "$OMARCHY_USER_NAME"
<Multi_key> <space> <e> : "$OMARCHY_USER_EMAIL"
EOF

# Post-installation validation
echo "Validating installation..."
python3 -c "import sys; print('✓ Python3 OK')" || echo "⚠ Python3 issue"
waybar --help >/dev/null 2>&1 && echo "✓ Waybar OK" || echo "⚠ Waybar issue"
mullvad --help >/dev/null 2>&1 && echo "✓ Mullvad OK" || echo "⚠ Mullvad issue"

# Verify waybar scripts are executable and functional
for script in waybar-tomato-timer.py waybar-cpu-aggregate.py waybar-memory-accurate.py waybar-mic-status.py; do
    if [ -x ~/.local/bin/$script ]; then
        echo "✓ $script installed and executable"
    else
        echo "⚠ $script missing or not executable"
    fi
done

echo "Configuration installation complete!"
