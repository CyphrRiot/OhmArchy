# OhmArchy Fish Shell Configuration

This directory contains the default Fish shell configuration for OhmArchy.

## Features

- **Clean Configuration**: No personal information or system-specific CachyOS references
- **Goose Integration**: Includes `GOOSE_DISABLE_KEYRING=1` to prevent keyring issues
- **Auto-start Hyprland**: Automatically starts Hyprland on TTY1
- **Enhanced Aliases**: Useful aliases for development and daily use
- **Modern Tools**: Uses `eza` instead of `ls`, `bat` instead of `cat`, `nvim` instead of `vim`
- **Git Integration**: Common git aliases for faster workflow
- **FZF Integration**: Enhanced fuzzy finding if FZF is installed

## Installation

This configuration is automatically installed when running the OhmArchy installation scripts:

```bash
./install/3-terminal.sh
```

The script will:
1. Install Fish shell and related tools
2. Copy the default configuration to `~/.config/fish/config.fish`
3. Set Fish as the default shell

## Key Features

### Environment Variables
- `GOOSE_DISABLE_KEYRING=1` - Prevents keyring-related issues with Goose
- `EDITOR=nvim` - Sets Neovim as the default editor
- `TERMINAL=alacritty` - Sets Alacritty as the default terminal

### Aliases
- `ls` → `eza` (better file listing)
- `cat` → `bat` (syntax highlighting)
- `vim` → `nvim` (modern Vim)
- Git shortcuts: `gs`, `ga`, `gc`, `gp`, `gl`, `gd`

### Functions
- **Enhanced Goose**: Automatic MCP server extension for better session handling
- **Custom Greeting**: Shows system info with Arch logo using fastfetch

## Customization

Users can extend this configuration by editing `~/.config/fish/config.fish` after installation, but this base configuration provides a solid foundation for Arch Linux development.

## No Personal Information

This configuration is designed to be distributed with OhmArchy and contains no personal information, API keys, or system-specific configurations that would be inappropriate to share.
