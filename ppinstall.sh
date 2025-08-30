#!/bin/bash
# Disable touchpads, install Steam & NetworkManager, setup prime-run for Steam with proper scaling

set -e

echo "This script will disable all touchpads, install NetworkManager, Steam, prime-run, and configure Steam to run with prime-run and 1.25 scaling."

# Confirm before proceeding
read -rp "Do you want to continue? [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborting."
    exit 1
fi

# --- Disable touchpads ---
echo "Disabling touchpads..."
sudo tee /etc/udev/rules.d/90-disable-touchpad.rules >/dev/null <<'EOF'
# Ignore all touchpads for libinput (Wayland/wlroots/Hyprland will not see them)
SUBSYSTEM=="input", ENV{ID_INPUT_TOUCHPAD}=="1", ENV{LIBINPUT_IGNORE_DEVICE}="1"
EOF

sudo udevadm control --reload-rules
sudo udevadm trigger -c add -s input
echo "Touchpads disabled."

# --- Update package database ---
echo "Updating package database..."
sudo pacman -Syu --noconfirm

# --- Install NetworkManager ---
echo "Installing NetworkManager..."
sudo pacman -S --noconfirm networkmanager

# --- Install Steam ---
echo "Installing Steam..."
sudo pacman -S --noconfirm steam

# --- Install prime-run ---
echo "Installing prime-run (nvidia-prime package)..."
sudo pacman -S --noconfirm nvidia-prime

# --- Configure Steam desktop file ---
STEAM_DESKTOP_FILE="/usr/share/applications/steam.desktop"

if [[ -f "$STEAM_DESKTOP_FILE" ]]; then
    echo "Backing up original Steam desktop file..."
    sudo cp "$STEAM_DESKTOP_FILE" "${STEAM_DESKTOP_FILE}.bak"

    echo "Editing Steam desktop file to use prime-run and scale to 1.25..."
    # Prepend environment variable to Exec line
    sudo sed -i 's|^Exec=.*|Exec=env STEAM_FORCE_DESKTOPUI_SCALING=1.25 prime-run /usr/bin/steam %U|' "$STEAM_DESKTOP_FILE"

    echo "Steam desktop file updated."
else
    echo "Warning: Steam desktop file not found at $STEAM_DESKTOP_FILE"
fi

echo "All done! Touchpads disabled, NetworkManager and Steam installed, Steam configured to run with prime-run at 1.25 scale."
