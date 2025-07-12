# ==============================================================================
# Filesystem Support Installation Script
# ==============================================================================
# Installs essential filesystem drivers and mounting support for:
# - NTFS (Windows partitions, external drives)
# - exFAT (modern USB drives, SD cards)
# - FAT32/VFAT (older USB drives, camera cards)
# - Removable media integration with Thunar
# ==============================================================================

# Define critical filesystem packages that must succeed
critical_packages=(
    "ntfs-3g"           # NTFS read/write support
    "exfatprogs"        # exFAT filesystem support
    "gvfs"              # GNOME Virtual File System for Thunar integration
    "udisks2"           # Automatic disk mounting and management
)

# Define optional filesystem packages that can fail
optional_packages=(
    "dosfstools"        # FAT32/VFAT support and utilities
    "gvfs-mtp"          # Android device support via MTP
    "gvfs-gphoto2"      # Digital camera support
    "gvfs-smb"          # Windows network share support
    "gvfs-nfs"          # Network File System support
)

# Install critical filesystem packages - failure stops installation
echo "Installing critical filesystem support..."
for package in "${critical_packages[@]}"; do
    echo "Installing: $package"
    if yay -S --noconfirm --needed "$package"; then
        echo "✓ Success: $package"
    else
        echo "Error: Failed to install critical filesystem package: $package"
        echo "External drives and removable media will not work without this package."
        exit 1
    fi
done

# Install optional filesystem packages - failure continues with warning
echo "Installing optional filesystem support..."
for package in "${optional_packages[@]}"; do
    echo "Installing: $package"
    if yay -S --noconfirm --needed "$package"; then
        echo "✓ Success: $package"
    else
        echo "⚠ Failed: $package (optional - continuing...)"
    fi
done

# Validate critical filesystem support is available
echo "Validating filesystem support..."

# Check NTFS support
if ! command -v mount.ntfs &>/dev/null && ! command -v ntfs-3g &>/dev/null; then
    echo "Error: NTFS support not found after installation"
    exit 1
fi

# Check exFAT support
if ! command -v mount.exfat &>/dev/null && ! modinfo exfat &>/dev/null; then
    echo "Error: exFAT support not found after installation"
    exit 1
fi

# Check udisks2 service
if ! systemctl is-enabled udisks2.service &>/dev/null; then
    echo "Enabling udisks2 service for automatic mounting..."
    sudo systemctl enable udisks2.service
fi

echo "✓ Filesystem support validated"

# Configure proper mount options for security and performance
echo "Configuring filesystem mount options..."

# Create udisks2 mount options configuration
sudo mkdir -p /etc/udisks2
sudo tee /etc/udisks2/mount_options.conf >/dev/null <<EOF
# Mount options for different filesystems
[defaults]
ntfs_defaults=uid=\$UID,gid=\$GID,dmask=022,fmask=133,windows_names
exfat_defaults=uid=\$UID,gid=\$GID,dmask=022,fmask=133
vfat_defaults=uid=\$UID,gid=\$GID,dmask=022,fmask=133,utf8
EOF

echo "✓ Filesystem support installation complete!"
echo "  - NTFS: Windows partitions and external drives"
echo "  - exFAT: Modern USB drives and SD cards"
echo "  - FAT32: Older USB drives and camera cards"
echo "  - Thunar: Automatic removable media detection"
echo "  - udisks2: Password-free mounting for user"
