yay -S --noconfirm --needed \
  hyprland hyprshot hyprpicker hyprlock hypridle polkit-gnome hyprland-qtutils \
  wofi waybar mako swaybg \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  grim slurp

# Start Hyprland on first session - supporting both bash and fish
echo "[[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]] && exec Hyprland" >~/.bash_profile

# Create fish config directory if it doesn't exist and setup Hyprland autostart
mkdir -p ~/.config/fish
echo "if status is-interactive; and test -z \$DISPLAY; and test (tty) = /dev/tty1; exec Hyprland; end" >~/.config/fish/config.fish
