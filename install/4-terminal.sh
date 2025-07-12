#!/bin/bash

# OhmArchy Terminal & Fish Shell Setup Script
# Installs Fish shell with self-contained OhmArchy configuration

echo "🐠 Setting up Fish shell with OhmArchy configuration..."

# Install core terminal packages
echo "Installing terminal packages..."
yay -S --noconfirm --needed \
  wget curl unzip inetutils \
  fd eza fzf ripgrep zoxide bat \
  wl-clipboard fastfetch btop \
  man tldr less whois plocate bash-completion \
  kitty fish git lsd neovim

# Verify Fish was installed successfully
if ! command -v fish &> /dev/null; then
    echo "❌ Fish installation failed, falling back to bash"
    exit 1
fi

echo "✓ Fish shell installed successfully"

# Create fish config directory
echo "Setting up Fish configuration directory..."
mkdir -p ~/.config/fish

# Copy OhmArchy's self-contained fish configuration
echo "Installing OhmArchy Fish configuration..."
if [ -f ~/.local/share/omarchy/config/fish/config.fish ]; then
    cp ~/.local/share/omarchy/config/fish/config.fish ~/.config/fish/config.fish
    echo "✓ Fish configuration copied successfully"
else
    echo "⚠ Fish config not found at ~/.local/share/omarchy/config/fish/config.fish"
    exit 1
fi

# Set fish as default shell
echo "Setting Fish as default shell..."
if [ -f /usr/bin/fish ]; then
    sudo chsh -s /usr/bin/fish $USER
    echo "✓ Fish set as default shell (will take effect on next login)"
else
    echo "⚠ Fish binary not found at /usr/bin/fish"
    exit 1
fi

# Test Fish configuration
echo "Testing Fish configuration..."
if fish -c "source ~/.config/fish/config.fish && echo 'Fish configuration test successful'" &> /dev/null; then
    echo "✓ Fish configuration loads without errors"
else
    echo "⚠ Fish configuration has syntax errors"
    echo "Check ~/.config/fish/config.fish for issues"
    exit 1
fi

# Test custom prompt function
echo "Testing Fish prompt..."
if fish -c "functions -q fish_prompt" &> /dev/null; then
    echo "✓ Fish prompt function available"
else
    echo "⚠ Fish prompt function missing"
    exit 1
fi

# Test git integration
echo "Testing Git prompt integration..."
if fish -c "functions -q __fish_git_prompt" &> /dev/null; then
    echo "✓ Git prompt integration available"
else
    echo "⚠ Git prompt integration missing"
fi

# Force fish to reload configuration
echo "Reloading Fish configuration..."
fish -c "source ~/.config/fish/config.fish" 2>/dev/null && echo "✓ Fish configuration reloaded"

# Final validation
echo "🔍 Final Fish setup validation..."

# Test greeting
fish -c "fish_greeting" &>/dev/null && echo "✓ Fish greeting works" || echo "⚠ Fish greeting has issues"

# Test prompt generation
if fish -c "fish_prompt" &>/dev/null; then
    echo "✓ Fish prompt generates successfully"
    echo "🎉 Self-contained Fish shell with OhmArchy configuration installed!"
else
    echo "⚠ Fish prompt generation failed"
    exit 1
fi

# Show example of what the prompt looks like
echo ""
echo "🐠 Your new Fish shell prompt preview:"
fish -c "
    echo -n 'Example: '
    fish_prompt
    echo 'command_here'
"

echo ""
echo "✅ Fish shell setup complete!"
echo "💡 Features:"
echo "   • Ohm symbol (Ω) prompt with full directory paths"
echo "   • Git integration with status symbols (⚡→☡↩+-)"
echo "   • Fastfetch with Arch logo greeting"
echo "   • vim → nvim alias included"
echo "   • Zero external dependencies (self-contained)"
echo "   • Type 'fish' to test your new shell now"
