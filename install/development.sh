yay -S --noconfirm --needed \
  cargo clang llvm \
  imagemagick \
  mariadb-libs postgresql-libs \
  github-cli \
  lazygit \
  zed

# Download latest migrate binary from CypherRiot/Migrate
echo "Installing latest migrate binary..."
mkdir -p ~/.local/bin
wget -O ~/.local/bin/migrate https://github.com/CyphrRiot/Migrate/raw/main/bin/migrate
chmod +x ~/.local/bin/migrate
