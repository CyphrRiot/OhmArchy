# Exit immediately if a command exits with a non-zero status
set -e

# Give people a chance to retry running the installation
trap 'echo "OhmArchy installation failed! You can retry by running: source ~/.local/share/omarchy/install.sh"' ERR

# Install everything
for f in ~/.local/share/omarchy/install/*.sh; do
  echo -e "\nRunning installer: $f"
  source "$f"
done

# Ensure locate is up to date now that everything has been installed
sudo updatedb

# Final installation validation
echo -e "\n🔍 Final Installation Validation"
echo "================================="

# Test critical components
waybar --version >/dev/null 2>&1 && echo "✓ Waybar installed" || echo "⚠ Waybar installation issue"
hyprland --version >/dev/null 2>&1 && echo "✓ Hyprland installed" || echo "⚠ Hyprland installation issue"
mullvad --version >/dev/null 2>&1 && echo "✓ Mullvad installed" || echo "⚠ Mullvad installation issue"

# Check theme system
if [ -L ~/.config/omarchy/current/theme ]; then
    echo "✓ Theme system configured"
else
    echo "⚠ Theme system issue"
fi

# Check waybar scripts
script_count=$(find ~/.local/bin -name "waybar-*.py" -executable | wc -l)
if [ $script_count -ge 4 ]; then
    echo "✓ Waybar scripts installed ($script_count found)"
else
    echo "⚠ Missing waybar scripts (found $script_count, expected 4+)"
fi

echo "================================="
echo "🎉 OhmArchy installation complete!"

gum confirm "Reboot to apply all settings?" && reboot
