#!/usr/bin/env bash
username="$1"

# Clone the repo
echo "Cloning the EOS Community Sway repo..."
git clone https://github.com/killajoe/sway.git

# Install the custom package list
echo "Installing needed packages..."
pacman -S --noconfirm --noprogressbar --needed --disable-download-timeout $(< ./sway/packages-repository.txt)

# Deploy user configs
echo "Deploying user configs..."
rsync -a sway/.config "/home/${username}/"
rsync -a sway/.local "/home/${username}/"
rsync -a sway/home_config/ "/home/${username}/"
# Restore user ownership
chown -R "${username}:${username}" "/home/${username}"

# Deploy system configs
echo "Deploying system configs..."
rsync -a --chown=root:root sway/etc/ /etc/

# Remove the repo
echo "Removing the EOS Community Sway repo..."
rm -rf sway

# Enable the ly service
echo "Enabling the ly service..."
systemctl enable ly.service

echo "Installation complete."
