yay -S --noconfirm --needed \
  wget curl unzip inetutils impala \
  fd eza fzf ripgrep zoxide bat \
  wl-clipboard fastfetch btop \
  man tldr less whois plocate bash-completion \
  kitty fish

# Verify Fish was installed successfully
if ! command -v fish &> /dev/null; then
    echo "⚠ Fish installation failed, falling back to bash"
    exit 1
fi

# Create fish config directory and copy default configuration
echo "Setting up Fish shell configuration..."
mkdir -p ~/.config/fish

# Copy OhmArchy's default fish configuration with verification
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OHMARCHY_ROOT="$(dirname "$SCRIPT_DIR")"

if [ -f "$OHMARCHY_ROOT/config/fish/config.fish" ]; then
    cp "$OHMARCHY_ROOT/config/fish/config.fish" ~/.config/fish/config.fish
    echo "✓ Fish configuration copied successfully"
else
    echo "⚠ Fish config not found at $OHMARCHY_ROOT/config/fish/config.fish"
    exit 1
fi

# Set up Fish completions directory
mkdir -p ~/.config/fish/completions

# Verify Fish config was copied correctly
if [ -f ~/.config/fish/config.fish ]; then
    echo "✓ Fish configuration verified"
else
    echo "⚠ Fish configuration copy failed"
    exit 1
fi

# Set fish as default shell with verification
if [ -f /usr/bin/fish ]; then
    echo "Setting Fish as default shell..."
    sudo chsh -s /usr/bin/fish $USER
    echo "✓ Fish set as default shell (will take effect on next login)"
else
    echo "⚠ Fish binary not found at /usr/bin/fish"
    exit 1
fi

# Test Fish configuration
echo "Testing Fish configuration..."
if fish -c "echo 'Fish configuration test successful'" &> /dev/null; then
    echo "✓ Fish configuration loads without errors"
else
    echo "⚠ Fish configuration has syntax errors"
    echo "Check ~/.config/fish/config.fish for issues"
fi
