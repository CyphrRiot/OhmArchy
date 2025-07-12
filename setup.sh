ascii_art=' ▄██████▄   ██    ██  ████████████    ▄████████    ▄████████    ▄█    █▄    ▄██   ▄
███    ███  ██    ██  ██    ██   ██   ███    ███   ███    ███   ███    ███   ███   ██▄
███    ███  ██▀▀▀▀██  ██    ██   ██   ███    ███   ███    █▀    ███    ███   ███▄▄▄███
███    ███  ██    ██  ████████████   ███    ███  ▄███▄▄▄▄██▀  ▄███▄▄▄▄███▄▄ ▀▀▀▀▀▀███
███    ███  ██▀▀▀▀██  ██    ██   ██ ▀███████████ ▀▀███▀▀▀▀▀   ▀▀███▀▀▀▀███▀  ▄██   ███
███    ███  ██    ██  ██    ██   ██   ███    ███ ▀███████████   ███    ███   ███   ███
███    ███  ██    ██  ██    ██   ██   ███    ███   ███    ███   ███    ███   ███   ███
 ▀██████▀   ██    ██  ██    ██   ██   ███    █▀    ███    ███   ███    █▀     ▀█████▀
                                                  ███    ███                         '

echo -e "\n$ascii_art\n"

pacman -Q git &>/dev/null || sudo pacman -Sy --noconfirm --needed git

echo -e "\nCloning OhmArchy..."
rm -rf ~/.local/share/omarchy/
if ! git clone https://github.com/CyphrRiot/OhmArchy.git ~/.local/share/omarchy; then
    echo "Error: Failed to clone OhmArchy repository. Check your internet connection and try again."
    exit 1
fi

# Use custom branch if instructed
if [[ -n "$OMARCHY_REF" ]]; then
  echo -e "\nUsing branch: $OMARCHY_REF"
  if ! cd ~/.local/share/omarchy; then
    echo "Error: Failed to enter OhmArchy directory"
    exit 1
  fi
  if ! git fetch origin "${OMARCHY_REF}"; then
    echo "Error: Failed to fetch branch ${OMARCHY_REF}"
    exit 1
  fi
  if ! git checkout "${OMARCHY_REF}"; then
    echo "Error: Failed to checkout branch ${OMARCHY_REF}. Branch may not exist."
    exit 1
  fi
  cd -
fi

echo -e "\nOhmArchy installation starting..."
source ~/.local/share/omarchy/install.sh
