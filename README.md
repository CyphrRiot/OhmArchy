# OhmArchy

**A customized Arch Linux setup based on Omarchy, optimized for the CypherRiot workflow.**

Turn a fresh Arch installation into a fully-configured, beautiful, and modern development system based on Hyprland by running a single command. OhmArchy is a personal fork of [Basecamp's Omarchy](https://github.com/basecamp/omarchy) with extensive customizations focused on privacy, development productivity, and clean aesthetics.

## 🎯 Key Customizations

### 🔧 **Core System Changes**
- **Terminal:** Kitty (replaces Alacritty)
- **Browser:** Brave (replaces Chromium) 
- **File Manager:** Thunar (replaces Nautilus)
- **Shell:** Fish as default (replaces Bash) with proper PATH configuration
- **Theme:** CypherRiot as default (replaces Tokyo Night)
- **Code Editor:** Added Zed alongside Neovim
- **Backup Tool:** Latest migrate binary for comprehensive system backup/restore

### 📱 **Clean Web Applications**
- **Proton Mail** (SUPER+E) - Privacy-focused email
- **ChatGPT** (SUPER+A) - AI assistant
- **Google Messages** (SUPER+ALT+G) - Communication
- **X/Twitter** (SUPER+X) - Social platform
- **GitHub, Google Photos, Google Contacts** - All with proper icons from homarr-labs

### ⌨️ **Enhanced Keybindings & Productivity**
- **SUPER+D** = **SUPER+SPACE** (Unified app launcher)
- **SUPER+SHIFT+S** - Region screenshot (primary)
- **SUPER+SHIFT+W** - Window screenshot
- **SUPER+SHIFT+F** - Full screen screenshot
- **Key repeat enabled** (40 rate, 600 delay for responsive typing)
- **All media keys** - Volume, brightness, playback controls

### 🎨 **Document & Media Handling**
- **Apostrophe** - Default for text/markdown files (clean, distraction-free writing)
- **Papers** - Default PDF viewer (GNOME's modern document viewer)
- **MPV** - Video playback with optimal performance
- **Better waybar network** - nmtui instead of impala for reliable WiFi management
- **Screenshot tools** - grim/slurp/hyprshot integration for all capture needs

### 🚫 **Removed Bloat & Corporate Apps**
- **Removed 37signals/Basecamp tools** - Hey, Basecamp web apps
- **Removed corporate social** - Discord, proprietary messaging
- **Removed heavy productivity** - Obsidian, LibreOffice, OBS Studio, KDEnlive, Pinta
- **Removed proprietary services** - 1Password, Typora, Dropbox, Spotify, Zoom
- **Removed entertainment** - YouTube webapp, WhatsApp webapp

## 🚀 Installation


### Method 1: Boot Script (Fresh Arch Systems)
```bash
curl -fsSL https://cyphrriot.github.io/OhmArchy/boot.sh | bash
```

### Method 2: Manual Clone (For Customization)
```bash
git clone https://github.com/CyphrRiot/OhmArchy.git ~/.local/share/omarchy
~/.local/share/omarchy/install.sh
```

## 🔄 System Management

### Updates
```bash
omarchy-update
```
Pulls the latest OhmArchy changes and updates system packages.

### Backup & Restore
```bash
migrate
```
**Note:** `migrate` is a TUI (Text User Interface) with **no command-line options**. Simply run the command and use the interactive menu to:
- Create comprehensive system backups
- Restore from previous backups  
- Migrate configurations between installations
- Preserve all your customizations

The migrate tool automatically downloads the latest version during installation from [CypherRiot/Migrate](https://github.com/CyphrRiot/Migrate).

## 🎨 Themes & Customization

### Available Themes
OhmArchy includes multiple themes with CypherRiot as the default:
- **cypherriot** (default) - Custom purple/blue aesthetic
- **catppuccin** - Pastel perfection
- **everforest** - Green nature vibes  
- **gruvbox** - Retro warm colors
- **kanagawa** - Japanese ink painting
- **nord** - Arctic cool tones
- **tokyo-night** - Vibrant city lights

### Theme Management
- **Switch themes:** `omarchy-theme-next` or manually symlink
- **Theme location:** `~/.config/omarchy/current/theme`
- **Backgrounds:** Automatically matched to theme with time-based variants

## ⚡ Key Features & Performance

### Window Management
- **Hyprland compositor** - Smooth animations, efficient memory usage
- **GPU acceleration** - Automatic NVIDIA, AMD/Radeon, and Intel driver setup with Vulkan support
- **Tiling & floating** - Flexible window arrangements
- **Multi-workspace** - Organized workflow separation
- **Auto-login** - Direct to tty1 with Hyprland autostart

### Development Ready
- **Fish shell** - Modern, user-friendly command line with autocompletion
- **Modern CLI tools** - eza, bat, ripgrep, fzf, zoxide for enhanced productivity
- **Git integration** - GitHub CLI, lazygit, proper aliases
- **Code editors** - Zed (modern), Neovim (power user)
- **Container support** - Docker, development environments

### Privacy & Security Focus
- **Brave browser** - Ad blocking, privacy protection by default
- **Proton Mail** - End-to-end encrypted email
- **Mullvad VPN** - Anonymous browsing capabilities
- **Local tools** - Reduced dependency on cloud services
- **Clean telemetry** - Minimal data collection

### Audio & Media
- **PipeWire/WirePlumber** - Modern audio stack
- **MPV** - Lightweight, powerful video player
- **Screenshot integration** - Multiple capture methods with clipboard support

## 🔀 Differences from Original Omarchy

This is a **heavily customized fork** optimized for:

### Philosophy Changes
- **Privacy over convenience** - Proton Mail vs. corporate email
- **Performance over features** - Lightweight apps vs. feature-heavy alternatives
- **Development focus** - Tools for coding vs. general productivity
- **Clean aesthetics** - Minimal, distraction-free environment

### Technical Changes
- **Modern shell** - Fish with intelligent defaults
- **Better package selection** - Proven, lightweight alternatives
- **Enhanced keybindings** - More intuitive, conflict-free shortcuts
- **Improved theming** - Consistent dark mode throughout
- **Advanced backup** - Comprehensive migration capabilities

## 📂 Repository Information

- **Main Repository:** https://github.com/CyphrRiot/OhmArchy
- **Original Upstream:** https://github.com/basecamp/omarchy
- **Maintenance:** Active, with regular updates and improvements
- **Community:** Open to issues, suggestions, and contributions

## 📋 System Requirements

- **Fresh Arch Linux installation** (recommended)
- **Internet connection** for package downloads
- **4GB+ RAM** (8GB+ recommended for development)
- **20GB+ storage** (50GB+ for full development setup)
- **CPU:** Any modern processor (optimized for both Intel/AMD)
- **GPU:** Automatic detection and setup for NVIDIA, AMD/Radeon, and Intel graphics cards

## 📄 License

OhmArchy is released under the [MIT License](https://opensource.org/licenses/MIT), maintaining compatibility with the original Omarchy project while enabling community contributions and modifications.

