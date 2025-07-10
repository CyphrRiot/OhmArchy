yay -S --noconfirm --needed \
  wget curl unzip inetutils impala \
  fd eza fzf ripgrep zoxide bat \
  wl-clipboard fastfetch btop \
  man tldr less whois plocate bash-completion \
  kitty fish

# Create fish config directory and setup
mkdir -p ~/.config/fish

# Add ~/.local/bin to PATH for fish shell
echo "fish_add_path ~/.local/bin" >>~/.config/fish/config.fish

# Set fish as default shell
sudo chsh -s /usr/bin/fish $USER
