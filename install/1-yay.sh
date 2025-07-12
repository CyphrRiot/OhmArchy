sudo pacman -S --needed --noconfirm base-devel

if ! command -v yay &>/dev/null; then
  echo "Installing yay AUR helper..."
  if ! cd /tmp; then
    echo "Error: Failed to change to /tmp directory"
    exit 1
  fi
  if ! git clone https://aur.archlinux.org/yay-bin.git; then
    echo "Error: Failed to clone yay-bin from AUR. Check your internet connection."
    exit 1
  fi
  if ! cd yay-bin; then
    echo "Error: Failed to enter yay-bin directory"
    exit 1
  fi
  if ! makepkg -si --noconfirm; then
    echo "Error: Failed to build and install yay"
    cd /tmp
    rm -rf yay-bin
    exit 1
  fi
  cd /tmp
  rm -rf yay-bin
  cd ~

  # Verify yay was actually installed
  if ! command -v yay &>/dev/null; then
    echo "Error: yay installation failed - command not found after installation"
    exit 1
  fi
  echo "✓ yay installed successfully"
fi
