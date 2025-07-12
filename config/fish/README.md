# OhmArchy Fish Shell Configuration

This directory contains the beautiful Fish shell configuration for OhmArchy with Tide prompt.

## Features

- **Tide Prompt**: Beautiful, fast, and feature-rich prompt with git integration
- **CachyOS Base Config**: Enhanced configuration with system optimizations
- **Goose Integration**: AI assistant integration with environment detection
- **Auto-start Hyprland**: Automatically starts Hyprland on TTY1
- **Enhanced Aliases**: Useful aliases for development and daily use
- **Modern Tools**: Uses `eza` instead of `ls`, `bat` instead of `cat`, `nvim` instead of `vim`
- **Smart Navigation**: Zoxide integration for intelligent directory jumping
- **Git Integration**: Common git aliases for faster workflow
- **FZF Integration**: Enhanced fuzzy finding if FZF is installed
- **Fisher Plugin Manager**: Easy plugin management for Fish
- **Cursor Theme**: Bibata-Modern-Ice cursor configuration

## Installation

This configuration is automatically installed when running the OhmArchy installation scripts:

```bash
./install/4-terminal.sh
```

The script will:

1. Install Fish shell and related tools
2. Install Fisher plugin manager
3. Install Tide prompt via Fisher
4. Copy the beautiful configuration to `~/.config/fish/config.fish`
5. Copy all Tide functions to `~/.config/fish/functions/`
6. Set Fish as the default shell
7. Configure Tide with beautiful defaults
8. Verify configuration loads without errors

## Key Features

### Tide Prompt

- **Beautiful Design**: Two-line prompt with git branch, time, and status
- **Fast Performance**: Asynchronous rendering for responsive experience
- **Git Integration**: Shows branch, status, and changes at a glance
- **Customizable**: Run `tide configure` to personalize your prompt
- **Smart Features**: Context-aware display of directory, jobs, and duration

### Environment Variables

- Sources CachyOS fish configuration for enhanced functionality
- Custom greeting with Arch logo and system information
- Goose AI assistant integration with environment detection
- `EDITOR=nvim` - Sets Neovim as the default editor
- `TERMINAL=kitty` - Sets Kitty as the default terminal
- `XCURSOR_THEME=Bibata-Modern-Ice` - Beautiful cursor theme

### Aliases

- `ls` → `eza` (better file listing)
- `cat` → `bat` (syntax highlighting)
- `vim` → `nvim` (modern Vim)
- `cd` → `z` (smart directory jumping with zoxide)
- `find` → `fd` (faster file finding)
- `grep` → `rg` (faster searching with ripgrep)
- Git shortcuts: `gs`, `ga`, `gc`, `gp`, `gl`, `gd`

### Functions & Integrations

- **Tide Prompt**: Complete prompt system with git, time, and status indicators
- **Enhanced Goose**: AI assistant integration with environment detection
- **Custom Greeting**: Shows system info with Arch logo using fastfetch
- **Fisher Plugins**: Plugin manager for easy Fish shell extensions
- **Zoxide Integration**: Automatic initialization for smart directory jumping
- **FZF Integration**: Enhanced fuzzy finding with custom options

## Customization

Users can customize their Fish experience in several ways:

- **Tide Configuration**: Run `tide configure` to personalize prompt appearance
- **Fisher Plugins**: Use `fisher install <plugin>` to add new functionality
- **Custom Functions**: Add functions to `~/.config/fish/functions/`
- **Config Extension**: Edit `~/.config/fish/config.fish` for additional customizations

This base configuration provides a beautiful, functional foundation for Arch Linux development.

## Clean & Shareable

This configuration is designed to be distributed with OhmArchy and contains:

- No personal information or API keys
- No system-specific configurations
- Beautiful defaults that work for all users
- Enhanced functionality while maintaining privacy
- Tide prompt with tasteful color scheme and layout
