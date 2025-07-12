#!/bin/bash

# OhmArchy Terminal & Fish Shell Setup Script
# Installs Fish shell with Tide prompt and beautiful configuration

echo "🐠 Setting up Fish shell with Tide prompt..."

# Install core terminal packages
echo "Installing terminal packages..."
yay -S --noconfirm --needed \
  wget curl unzip inetutils \
  fd eza fzf ripgrep zoxide bat \
  wl-clipboard fastfetch btop \
  man tldr less whois plocate bash-completion \
  kitty fish git

# Verify Fish was installed successfully
if ! command -v fish &> /dev/null; then
    echo "❌ Fish installation failed, falling back to bash"
    exit 1
fi

echo "✓ Fish shell installed successfully"

# Create fish config directory structure
echo "Setting up Fish configuration directories..."
mkdir -p ~/.config/fish/{functions,completions,conf.d}

# Copy OhmArchy's fish configuration
echo "Installing OhmArchy Fish configuration..."
if [ -f ~/.local/share/omarchy/config/fish/config.fish ]; then
    cp ~/.local/share/omarchy/config/fish/config.fish ~/.config/fish/config.fish
    echo "✓ Fish configuration copied successfully"
else
    echo "⚠ Fish config not found at ~/.local/share/omarchy/config/fish/config.fish"
    exit 1
fi

# Copy all fish functions (including Tide functions)
echo "Installing Fish functions..."
if [ -d ~/.local/share/omarchy/config/fish/functions ]; then
    cp -r ~/.local/share/omarchy/config/fish/functions/* ~/.config/fish/functions/
    echo "✓ Fish functions copied successfully"
else
    echo "⚠ Fish functions directory not found"
    exit 1
fi

# Install Fisher (Fish plugin manager)
echo "Installing Fisher plugin manager..."
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" 2>/dev/null
if fish -c "functions -q fisher" &> /dev/null; then
    echo "✓ Fisher installed successfully"
else
    echo "⚠ Fisher installation failed - continuing without it"
fi

# Install Tide prompt via Fisher
echo "Installing Tide prompt..."
fish -c "fisher install IlanCosman/tide@v6" 2>/dev/null
if fish -c "functions -q tide" &> /dev/null; then
    echo "✓ Tide prompt installed successfully"
else
    echo "⚠ Tide installation failed - using existing functions"
fi

# Install additional useful Fish plugins
echo "Installing additional Fish plugins..."
fish -c "fisher install jorgebucaran/hydro" 2>/dev/null || echo "Note: Hydro installation optional"

# Set fish as default shell
echo "Setting Fish as default shell..."
if [ -f /usr/bin/fish ]; then
    sudo chsh -s /usr/bin/fish $USER
    echo "✓ Fish set as default shell (will take effect on next login)"
else
    echo "⚠ Fish binary not found at /usr/bin/fish"
    exit 1
fi

# Initialize and configure Tide if it was installed
echo "Configuring Tide prompt..."
fish -c "
    # Set Tide configuration to a beautiful preset
    set -U tide_character_icon '➜'
    set -U tide_character_color brred
    set -U tide_pwd_color_dirs bryellow
    set -U tide_pwd_color_anchors brcyan
    set -U tide_git_color_branch brmagenta
    set -U tide_time_color brblack
    set -U tide_context_color_default brblue
    set -U tide_prompt_add_newline_before true
    set -U tide_left_prompt_items context pwd git newline character
    set -U tide_right_prompt_items status cmd_duration jobs time
    set -U tide_prompt_color_frame_and_connection 6C7086
    echo '✓ Tide configuration applied'
" 2>/dev/null || echo "Note: Tide configuration skipped"

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

# Test Tide prompt specifically
if fish -c "functions -q _tide_item_pwd" &> /dev/null; then
    echo "✓ Tide prompt functions available"
else
    echo "⚠ Tide functions not found - using fallback prompt"
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
    echo "🎉 Beautiful Fish shell with Tide prompt installed!"
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
echo "💡 Tips:"
echo "   • Run 'tide configure' to customize your prompt"
echo "   • Use 'fisher list' to see installed plugins"
echo "   • Type 'fish' to test your new shell now"
echo "   • Your beautiful prompt will be active on next login"
