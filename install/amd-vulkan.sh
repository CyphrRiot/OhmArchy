# ==============================================================================
# AMD GPU Vulkan Setup Script for Arch Linux
# ==============================================================================
# This script automates the installation of AMD GPU drivers and Vulkan support
# for use with Hyprland on Arch Linux.
#
# Author: OhmArchy
#
# ==============================================================================

# --- GPU Detection ---
if [ -n "$(lspci | grep -i -E 'amd|radeon')" ]; then
  echo "AMD/Radeon GPU detected. Installing Vulkan drivers and tools..."

  # Enable multilib repository for 32-bit libraries
  if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
    sudo pacman -Sy
  fi

  # Install AMD Vulkan packages and related tools
  PACKAGES_TO_INSTALL=(
    "vulkan-radeon"      # AMD Vulkan driver
    "lib32-vulkan-radeon" # 32-bit AMD Vulkan driver for gaming
    "vulkan-tools"       # Vulkan utilities and info tools
    "mesa"               # Mesa 3D graphics library
    "lib32-mesa"         # 32-bit Mesa for compatibility
    "xf86-video-amdgpu"  # AMD GPU X.org driver
    "libva-mesa-driver"  # VA-API hardware acceleration
    "lib32-libva-mesa-driver" # 32-bit VA-API driver
    "mesa-vdpau"         # VDPAU hardware acceleration
    "lib32-mesa-vdpau"   # 32-bit VDPAU driver
  )

  # Install packages using pacman (these are all official repo packages)
  sudo pacman -S --needed --noconfirm "${PACKAGES_TO_INSTALL[@]}"

  # Verify Vulkan installation
  if command -v vulkaninfo >/dev/null 2>&1; then
    echo "✅ Vulkan installation successful!"
    echo "Testing Vulkan..."
    vulkaninfo --summary 2>/dev/null | head -10 || echo "Vulkan tools installed but may require reboot to function properly."
  else
    echo "⚠️  Vulkan tools installed but vulkaninfo command not found in PATH"
  fi

  # Add AMD environment variables to hyprland.conf if it exists
  HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"
  if [ -f "$HYPRLAND_CONF" ]; then
    echo "Adding AMD GPU environment variables to Hyprland config..."
    cat >>"$HYPRLAND_CONF" <<'EOF'

# AMD GPU environment variables
env = LIBVA_DRIVER_NAME,radeonsi
env = WLR_DRM_NO_ATOMIC,1
EOF
    echo "✅ AMD GPU configuration added to Hyprland"
  fi

  echo "✅ AMD Vulkan setup complete!"
  echo "Note: You may need to reboot for all changes to take effect."
else
  echo "No AMD/Radeon GPU detected. Skipping AMD Vulkan installation."
fi
