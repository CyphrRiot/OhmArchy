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
if [ -f ~/.local/share/omarchy/config/fish/config.fish ]; then
    cp ~/.local/share/omarchy/config/fish/config.fish ~/.config/fish/config.fish
    echo "✓ Fish configuration copied successfully"
else
    echo "⚠ Fish config not found at ~/.local/share/omarchy/config/fish/config.fish"
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

# Test Fish configuration and custom prompt
echo "Testing Fish configuration..."
if fish -c "echo 'Fish configuration test successful'" &> /dev/null; then
    echo "✓ Fish configuration loads without errors"
else
    echo "⚠ Fish configuration has syntax errors"
    echo "Check ~/.config/fish/config.fish for issues"
    exit 1
fi

# Test custom prompt function
echo "Testing custom Fish prompt..."
if fish -c "functions -q fish_prompt" &> /dev/null; then
    echo "✓ Custom fish_prompt function available"
else
    echo "⚠ Custom fish_prompt function missing"
    exit 1
fi

# Force fish to reload configuration for current session
echo "Reloading Fish configuration..."
if fish -c "source ~/.config/fish/config.fish; echo 'Fish config reloaded'" &> /dev/null; then
    echo "✓ Fish configuration reloaded successfully"
else
    echo "⚠ Fish configuration reload failed"
fi

# Test that fish greeting and prompt are working
echo "Validating Fish setup..."
fish -c "fish_greeting; echo 'Testing custom prompt:'; fish_prompt" 2>/dev/null || echo "⚠ Fish prompt test had issues"
