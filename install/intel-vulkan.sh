# ==============================================================================
# Intel GPU Vulkan Setup Script for Arch Linux
# ==============================================================================
# This script automates the installation of Intel GPU drivers and Vulkan support
# for use with Hyprland on Arch Linux. Supports both integrated and discrete Intel GPUs.
#
# Author: OhmArchy
#
# ==============================================================================

# --- GPU Detection ---
if [ -n "$(lspci | grep -i intel | grep -i -E 'vga|3d|display|graphics')" ]; then
  echo "Intel GPU detected. Installing Vulkan drivers and tools..."

  # Enable multilib repository for 32-bit libraries
  if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
    sudo pacman -Sy
  fi

  # Install Intel Vulkan packages and related tools
  PACKAGES_TO_INSTALL=(
    "vulkan-intel"           # Intel Vulkan driver
    "vulkan-tools"           # Vulkan utilities and info tools
    "mesa"                   # Mesa 3D graphics library
    "lib32-mesa"             # 32-bit Mesa for compatibility
    "intel-media-driver"     # Intel Media Driver for VAAPI (Broadwell+)
    "libva-intel-driver"     # VA-API driver for older Intel GPUs (up to Coffee Lake)
    "libva-mesa-driver"      # VA-API Mesa driver
    "lib32-libva-mesa-driver" # 32-bit VA-API Mesa driver
    "intel-gpu-tools"        # Intel GPU monitoring and debugging tools
  )

  # Check if lib32-vulkan-intel exists (not all repos may have it)
  if pacman -Ss lib32-vulkan-intel >/dev/null 2>&1; then
    PACKAGES_TO_INSTALL+=("lib32-vulkan-intel") # 32-bit Intel Vulkan driver for gaming
  fi

  # Check for Intel Arc or newer discrete GPUs that might need additional packages
  if lspci | grep -i intel | grep -i -E 'arc|xe|discrete'; then
    echo "Intel Arc/Xe discrete GPU detected, adding additional packages..."
    PACKAGES_TO_INSTALL+=(
      "intel-compute-runtime"  # OpenCL runtime for Intel GPUs
      "level-zero-loader"      # Level Zero API loader
    )
  fi

  # Install packages using pacman (these are all official repo packages)
  sudo pacman -S --needed --noconfirm "${PACKAGES_TO_INSTALL[@]}"

  # Configure Intel GPU for optimal performance
  # Add Intel-specific kernel parameters if not already present
  GRUB_CMDLINE_FILE="/etc/default/grub"
  if [ -f "$GRUB_CMDLINE_FILE" ]; then
    # Check if Intel GPU parameters are already set
    if ! grep -q "i915.enable_guc" "$GRUB_CMDLINE_FILE"; then
      echo "Adding Intel GPU optimization parameters to GRUB..."
      sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/&i915.enable_guc=2 /' "$GRUB_CMDLINE_FILE"
      sudo grub-mkconfig -o /boot/grub/grub.cfg
      echo "⚠️  Intel GPU optimization added to kernel parameters. Reboot required for full effect."
    fi
  fi

  # Verify Vulkan installation
  if command -v vulkaninfo >/dev/null 2>&1; then
    echo "✅ Vulkan installation successful!"
    echo "Testing Intel Vulkan..."
    vulkaninfo --summary 2>/dev/null | grep -i intel || echo "Intel Vulkan tools installed but may require reboot to function properly."
  else
    echo "⚠️  Vulkan tools installed but vulkaninfo command not found in PATH"
  fi

  # Add Intel environment variables to hyprland.conf if it exists
  HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"
  if [ -f "$HYPRLAND_CONF" ]; then
    echo "Adding Intel GPU environment variables to Hyprland config..."
    cat >>"$HYPRLAND_CONF" <<'EOF'

# Intel GPU environment variables
env = LIBVA_DRIVER_NAME,iHD
env = INTEL_DEBUG,sync
env = MESA_LOADER_DRIVER_OVERRIDE,iris
EOF
    echo "✅ Intel GPU configuration added to Hyprland"
  fi

  # Set up Intel GPU monitoring alias in fish config if it exists
  FISH_CONFIG="$HOME/.config/fish/config.fish"
  if [ -f "$FISH_CONFIG" ]; then
    if ! grep -q "intel_gpu_top" "$FISH_CONFIG"; then
      echo "" >> "$FISH_CONFIG"
      echo "# Intel GPU monitoring alias" >> "$FISH_CONFIG"
      echo "alias gpu-monitor='intel_gpu_top'" >> "$FISH_CONFIG"
    fi
  fi

  echo "✅ Intel Vulkan setup complete!"
  echo "📊 Use 'intel_gpu_top' or 'gpu-monitor' to monitor Intel GPU usage"
  echo "🔧 GuC (Graphics μController) firmware loading enabled for better performance"
  echo "Note: You may need to reboot for all changes to take effect."
else
  echo "No Intel GPU detected. Skipping Intel Vulkan installation."
fi
