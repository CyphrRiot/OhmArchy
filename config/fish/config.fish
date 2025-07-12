# Clean OhmArchy greeting
function fish_greeting
    # Show system info with Arch logo
    if command -v fastfetch >/dev/null 2>&1
        fastfetch --logo arch
    end

    # Then show OhmArchy welcome
    echo
    set_color cyan
    echo "🐧 Welcome to OhmArchy!"
    set_color normal
    echo
end

# Additional aliases to match zsh setup
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias ls='lsd'

# Goose function equivalent (Fish doesn't need the complex zsh syntax)
function goose
    if test "$argv[1]" = session; and contains -- -n $argv
        # Extract everything after "session" and prepend the extension
        set -l session_args $argv[2..]
        command goose session --with-extension "uvx mcp-server-fetch" $session_args
    else
        command goose $argv
    end
end

# History settings (Fish handles differently than zsh)
set -g fish_history_max_size 10000

# Set up FZF key bindings if available
if command -v fzf >/dev/null
    # This will be handled by FZF's fish integration if installed
end

# Use custom directory colors
if test -f ~/.config/dircolors/config
    eval (dircolors -c ~/.config/dircolors/config | sed 's/setenv/set -x/')
end
set -gx TERMINAL alacritty
