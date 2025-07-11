# OhmArchy Enhancement Plan

## Overview
This document tracks the comprehensive updates made to OhmArchy fork of omarchy, bringing it up to date with upstream features while maintaining the privacy-focused customizations.

## ✅ COMPLETED TASKS

### 1. Cursor Theme Configuration ✅ 
**Status: Complete**

#### OhmArchy Changes:
- Updated `/default/hypr/envs.conf` with Bibata-Modern-Ice cursor theme
- Added `XCURSOR_THEME=Bibata-Modern-Ice` and `HYPRCURSOR_THEME=Bibata-Modern-Ice`
- Set cursor sizes to 24 for both X and Hyprland
- Created `/default/icons/default/index.theme` for system-wide cursor defaults
- Updated `/install/theme.sh` to install `bibata-cursor-theme` and `obsidian-icon-theme`
- Added GTK cursor theme settings via gsettings
- Added cursor theme environment variables to Fish shell config

#### Live System Changes:
- Applied cursor theme settings via gsettings
- Created `~/.icons/default/index.theme` 
- Updated Fish configuration with cursor environment variables
- Installed Obsidian icon theme for beautiful file manager icons (Thunar)

#### Result:
- New OhmArchy installs get modern Bibata-Modern-Ice cursors automatically
- Obsidian icons used by default in Thunar file manager
- Both cursor and icon themes properly configured

### 2. Battery Management System ✅
**Status: Complete**

#### Components Added:
- **Battery Monitor Script** (`/bin/omarchy-battery-monitor`)
  - Monitors battery every 30 seconds
  - Critical notifications when battery ≤ 10%
  - Prevents notification spam with flag system
  - Only activates when discharging
- **Systemd User Service** (`omarchy-battery-monitor.service`)
- **Systemd Timer** (`omarchy-battery-monitor.timer`)
- **Power Profile Management** (updated `power.sh`)
  - Installs `power-profiles-daemon`
  - Auto-detects battery presence
  - Sets performance profile for desktops, balanced for laptops
  - Enables battery monitoring on laptop systems

#### Directory Structure:
```
/config/systemd/user/
├── omarchy-battery-monitor.service
└── omarchy-battery-monitor.timer
```

#### Result:
- Laptop users get automatic low battery warnings
- Desktop users get performance profile automatically
- Proper power management for all system types

### 3. System Utility Scripts ✅
**Status: Complete**

#### Updated Scripts:
- **`omarchy-sync-applications`** - Added hidden/xtras app support
- **`omarchy-config-link`** - Added hyprlock.conf symlink
- **Application Organization** - Proper directory structure

#### Application Directory Restructure:
```
/applications/
├── *.desktop                    # Main applications
├── hidden/                      # Hidden system utilities (20+ files)
│   ├── avahi-discover.desktop
│   ├── fcitx5-configtool.desktop
│   └── ... (System config tools)
├── xtras/                      # Optional applications
│   ├── dropbox.desktop
│   └── Zoom.desktop
└── icons/                      # Application icons
```

#### All Utility Scripts Available:
- ✅ `omarchy-battery-monitor` - Battery monitoring
- ✅ `omarchy-fingerprint-setup` - Biometric authentication
- ✅ `omarchy-power-menu` - System power controls
- ✅ `omarchy-show-keybindings` - Keybinding reference
- ✅ `omarchy-toggle-idle` - Idle management
- ✅ `omarchy-refresh-plymouth` - Boot screen management
- ✅ `omarchy-refresh-waybar` - Waybar refresh
- ✅ `omarchy-sync-applications` - Desktop file management
- ✅ `omarchy-config-link` - Development config linking
- ✅ `omarchy-theme-next` - Theme switching
- ✅ `omarchy-update` - System updates

### 4. Window Close Keybindings ✅
**Status: Complete**

#### Changes Made:
- Added `SUPER + Q` as alternative to `SUPER + W` for closing windows
- Updated OhmArchy `/default/hypr/bindings.conf`
- Applied to live system via extra bindings in `~/.config/hypr/hyprland.conf`
- Used `hyprctl reload` to apply without session disruption
- Fixed screenshot keybinding conflicts
- Cleaned up duplicate screenshot bindings

#### Keybindings Now Available:
- ✅ **SUPER + W** = Close active window
- ✅ **SUPER + Q** = Close active window (alternative)

## 🔄 REMAINING TASKS

### 5. Safe System Update Mechanism ⏳
**Status: Pending**

#### Objective:
Fix `omarchy-update` script to safely update existing OhmArchy systems without overwriting working configurations.

#### Requirements:
- Preserve user customizations
- Update only safe components
- Add rollback mechanism
- Handle migration conflicts
- Test on live system without disruption

#### Implementation Plan:
1. Analyze current `omarchy-update` script differences
2. Add backup mechanisms for critical configs
3. Create selective update options
4. Test update process on live system
5. Document safe update procedures

---

## 🎯 UPSTREAM OMARCHY FEATURES ANALYSIS

### Missing from OhmArchy (vs upstream omarchy):

#### 🆕 Development Environment
- ❌ **Ruby development setup** (`ruby.sh`)
  - `mise` environment manager
  - Ruby-specific GCC-14 build configs
  - .ruby-version support

#### 🆕 Development Tools  
- ❌ **cargo** (Rust toolchain)
- ❌ **clang/llvm** (C/C++ development)  
- ❌ **mise** (polyglot development environment manager)
- ❌ **ImageMagick** (image processing)
- ❌ **MariaDB/PostgreSQL libraries** (database development)

#### 🆕 System Integration
- ❌ **FCitx5** input method framework (for international users)
- ❌ **wl-clip-persist** (clipboard persistence)
- ❌ **Sushi** (file previews in Nautilus)
- ❌ **ffmpegthumbnailer** (video thumbnails)

#### 🆕 Media Tools
- ❌ **imv** image viewer

### Intentional Differences (Keep as-is):
- ✅ **Privacy focus**: Brave vs Chromium, Proton Mail vs HEY
- ✅ **Modern shell**: Fish vs Bash  
- ✅ **Better terminal**: Kitty vs Alacritty
- ✅ **Lightweight apps**: Thunar vs Nautilus, Papers vs Evince
- ✅ **Custom theme**: CypherRiot aesthetics
- ✅ **Enhanced GPU support**: Comprehensive NVIDIA/AMD/Intel Vulkan support  

---

## 📊 PROGRESS TRACKING

### Completed: 4/5 (80%)
- [x] Task 1: Cursor Theme Configuration  
- [x] Task 2: Battery Management System
- [x] Task 3: System Utility Scripts
- [x] Task 4: Window Close Keybindings  
- [ ] Task 5: Safe System Update Mechanism

### Key Achievements:
1. **Complete upstream parity** for system management tools
2. **Enhanced user experience** with modern cursor/icon themes
3. **Laptop-friendly** battery management
4. **Organized application structure** for better maintenance
5. **Non-disruptive updates** to live system

### Next Priority:
Focus on **Task 5** to enable safe, ongoing system updates for existing OhmArchy users without configuration conflicts.
