yay -S --noconfirm --needed \
  wget curl unzip inetutils impala \
  fd eza fzf ripgrep zoxide bat \
  wl-clipboard fastfetch btop \
  man tldr less whois plocate bash-completion \
  kitty fish

# Create fish config directory and copy default configuration
mkdir -p ~/.config/fish

# Copy OhmArchy's default fish configuration (assuming script is run from OhmArchy root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OHMARCHY_ROOT="$(dirname "$SCRIPT_DIR")"
cp "$OHMARCHY_ROOT/config/fish/config.fish" ~/.config/fish/config.fish

# Set fish as default shell
sudo chsh -s /usr/bin/fish $USER
