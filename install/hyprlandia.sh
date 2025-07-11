yay -S --noconfirm --needed \
  hyprland hyprshot hyprpicker hyprlock hypridle polkit-gnome hyprland-qtutils \
  wofi waybar mako swaybg \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  grim slurp

# Start Hyprland on first session - bash only (fish config handled in 3-terminal.sh)
echo "[[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]] && exec Hyprland" >~/.bash_profile
