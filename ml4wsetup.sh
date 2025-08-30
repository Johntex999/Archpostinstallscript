#!/bin/bash
set -e

# Set keyboard layout to German in Hyprland
hyprctl keyword input:kb_layout de

# Install Firefox (on Arch/Manjaro)
sudo pacman -S --noconfirm firefox

# Install the dotfiles installer
flatpak install -y flathub com.ml4w.dotfilesinstaller

# Run the installer
flatpak run com.ml4w.dotfilesinstaller &

# Open Firefox at the given URL
firefox https://mylinuxforwork.github.io/dotfiles/ &
