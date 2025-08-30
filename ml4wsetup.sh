#!/bin/bash
set -e

# Set keyboard layout to German in Hyprland
hyprctl keyword input:kb_layout de

# Install the dotfiles installer
flatpak install -y flathub com.ml4w.dotfilesinstaller

# Run the installer
flatpak run com.ml4w.dotfilesinstaller &

# Open Zen at the given URL
zen-browser https://mylinuxforwork.github.io/dotfiles/ &
