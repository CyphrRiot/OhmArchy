# OhmArchy

**A customized Arch Linux setup based on Omarchy, optimized for the CypherRiot workflow.**

Turn a fresh Arch installation into a fully-configured, beautiful, and modern development system based on Hyprland by running a single command. OhmArchy is a personal fork of [Basecamp's Omarchy](https://github.com/basecamp/omarchy) with extensive customizations.

## Key Customizations

### 🔧 **Core Changes**
- **Terminal:** Kitty (replaces Alacritty)
- **Browser:** Brave (replaces Chromium) 
- **File Manager:** Thunar (replaces Nautilus)
- **Shell:** Fish as default (replaces Bash)
- **Theme:** CypherRiot as default (replaces Tokyo Night)
- **Code Editor:** Added Zed alongside Neovim
- **Backup Tool:** Latest migrate binary for system backup/restore

### 📱 **Web Applications**
- **Proton Mail** (SUPER+E) - https://mail.proton.me/u/11/inbox
- **ChatGPT** (SUPER+A) - https://chatgpt.com
- **Google Messages** (SUPER+ALT+G)
- **X/Twitter** (SUPER+X)
- **GitHub, Google Photos, Google Contacts** - All with proper icons

### ⌨️ **Enhanced Keybindings**
- **SUPER+D** = **SUPER+SPACE** (App launcher)
- **SUPER+SHIFT+S** - Region screenshot (main)
- **SUPER+SHIFT+W** - Window screenshot
- **SUPER+SHIFT+F** - Full screen screenshot
- **Key repeat enabled** (40 rate, 600 delay)

### 🎨 **Text & Media**
- **Apostrophe** - Default for text/markdown files
- **Papers** - Default PDF viewer (GNOME's modern document viewer)
- **Better waybar network** - nmtui instead of impala
- **Screenshot tools** - grim/slurp/hyprshot integration

### 🚫 **Removed Applications**
- 37signals tools, Discord, 1Password
- Obsidian, LibreOffice, OBS Studio, KDEnlive, Pinta
- Typora, Dropbox, Spotify, Zoom
- YouTube, WhatsApp, Hey webapps

## Installation

### Method 1: Direct Install (Recommended)
```bash
wget -qO- https://raw.githubusercontent.com/CyphrRiot/OhmArchy/master/install.sh | bash
```

### Method 2: Boot Script (Fresh Arch Systems)
```bash
curl -fsSL https://raw.githubusercontent.com/CyphrRiot/OhmArchy/master/boot.sh | bash
```

### Method 3: Manual Clone
```bash
git clone https://github.com/CyphrRiot/OhmArchy.git ~/.local/share/omarchy
~/.local/share/omarchy/install.sh
```

## Updates
```bash
omarchy-update
```

This will pull the latest changes from the OhmArchy repository and update your system packages.

## Backup & Restore
OhmArchy includes the latest migration tool for easy backup and restore:

```bash
migrate
```

**Note:** `migrate` is a TUI (Text User Interface) with **no command-line options**. Simply run the command and use the interactive menu to:
- Create backups of your system configuration
- Restore from previous backups  
- Migrate settings between installations

The migrate tool automatically gets the latest version during installation from the [CypherRiot/Migrate](https://github.com/CyphrRiot/Migrate) repository.

## Themes
OhmArchy includes several themes with CypherRiot as the default:
- **cypherriot** (default)
- catppuccin
- everforest  
- gruvbox
- kanagawa
- nord
- tokyo-night

Switch themes with: `omarchy-theme-next` or manually symlink in `~/.config/omarchy/current/theme`

## Key Features
- **Hyprland** window manager with polished animations
- **Fish shell** with modern terminal tools (eza, bat, ripgrep, fzf, zoxide)
- **Development ready** - Git, Zed, Kitty, Docker, Mullvad VPN
- **Web-focused** - Brave browser with curated webapp shortcuts
- **Dark theme** throughout with CypherRiot styling
- **Screenshot tools** integrated with proper keybindings
- **Auto-login** to tty1 with Hyprland autostart

## Differences from Omarchy
This is a **heavily customized fork** that:
- Removes Basecamp/37signals specific tools and webapps
- Focuses on privacy (Proton Mail, Brave, Mullvad VPN)
- Optimizes for development workflow (Fish, Kitty, Zed)
- Uses CypherRiot theme and branding
- Maintains update compatibility with this fork

## Repository
- **Main:** https://github.com/CyphrRiot/OhmArchy
- **Original:** https://github.com/basecamp/omarchy (upstream)

## License
OhmArchy is released under the [MIT License](https://opensource.org/licenses/MIT), same as the original Omarchy.

