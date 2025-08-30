#!/bin/bash
set -e

# Ensure base-devel and git are installed
sudo pacman -S --needed --noconfirm base-devel git curl wget

# Install paru if not already installed
if ! command -v paru &>/dev/null; then
    echo "Installing paru..."
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    cd -
fi

# Install zen-browser-bin
paru -S --noconfirm zen-browser-bin
zen-browser

# Go to Downloads
mkdir -p ~/Downloads
cd ~/Downloads

# Get latest release download URL for sine-linux-x64
echo "Fetching latest release of sine..."
url=$(curl -s https://api.github.com/repos/CosmoCreeper/Sine/releases/latest \
    | grep "browser_download_url" \
    | grep "sine-linux-x64" \
    | cut -d '"' -f 4)

# Download the file
wget -O sine-linux-x64 "$url"

# Make it executable
chmod +x sine-linux-x64

# Run with sudo
sudo ./sine-linux-x64

# Run second script
chmod +x ml4wsetup.sh
./ml4wsetup.sh
