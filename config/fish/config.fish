# OhmArchy Fish Shell Configuration
# Clean, minimal configuration without personal information

# Add ~/.local/bin to PATH
fish_add_path ~/.local/bin

# Auto-start Hyprland on TTY1
if status is-interactive; and test -z $DISPLAY; and test (tty) = /dev/tty1; exec Hyprland; end

# Disable Goose keyring to prevent issues
set -x GOOSE_DISABLE_KEYRING 1

# Custom greeting with Arch logo and system info
function fish_greeting
    # Show system info with Arch logo
    if command -v fastfetch > /dev/null
        fastfetch --logo arch
    else
        echo "Welcome to OhmArchy!"
        echo "System: $(uname -s) $(uname -r)"
    end
    
    echo
    set_color cyan
    echo "🐧 Welcome to OhmArchy - Your Arch Linux Environment"
    set_color normal
    echo "   Shell: Fish $(fish --version | cut -d' ' -f3)"
    echo "   Environment: $XDG_CURRENT_DESKTOP on $(if test -n "$WAYLAND_DISPLAY"; echo "Wayland"; else; echo "X11"; end)"
    set_color green
    echo "   ✅ Ready for development!"
    set_color normal
    echo
end

# Useful aliases
alias l='ls -l'
alias la='ls -a' 
alias lla='ls -la'
alias ls='eza'  # Use eza instead of ls for better output
alias ll='eza -l'
alias tree='eza --tree'

# Development aliases
alias vim='nvim'
alias cat='bat'  # Use bat for syntax highlighting

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'

# Enhanced Goose function for better session handling
function goose
    if test "$argv[1]" = "session"; and contains -- "-n" $argv
        # Extract session args and add MCP server extension
        set -l session_args $argv[2..]
        command goose session --with-extension "uvx mcp-server-fetch" $session_args
    else
        command goose $argv
    end
end

# History settings
set -g fish_history_max_size 10000

# Set up FZF key bindings if available
if command -v fzf > /dev/null
    # FZF integration will be handled automatically
    set -x FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
end

# Use custom directory colors if available
if test -f ~/.config/dircolors/config
    eval (dircolors -c ~/.config/dircolors/config | sed 's/setenv/set -x/')
end

# Default terminal
set -gx TERMINAL alacritty

# Editor settings
set -gx EDITOR nvim
set -gx VISUAL nvim

# Pager settings
set -gx PAGER less
set -gx LESSCHARSET utf-8

# Development environment
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Cursor theme configuration
set -gx XCURSOR_THEME Bibata-Modern-Ice
set -gx HYPRCURSOR_THEME Bibata-Modern-Ice
set -gx XCURSOR_SIZE 24
set -gx HYPRCURSOR_SIZE 24
