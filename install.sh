#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/binkynz/nixos.git"
FLAKE_HOST="desktop"
DISK="/dev/nvme0n1"

red()   { printf '\033[1;31m%s\033[0m\n' "$*"; }
green() { printf '\033[1;32m%s\033[0m\n' "$*"; }
bold()  { printf '\033[1m%s\033[0m\n' "$*"; }

# --- preflight ---

if [ "$(id -u)" -ne 0 ]; then
    red "Run as root: sudo bash install.sh"
    exit 1
fi

if [ ! -f /etc/NIXOS ]; then
    red "This script is meant to run from the NixOS live installer."
    red "Boot a NixOS ISO first."
    exit 1
fi

if [ ! -b "$DISK" ]; then
    red "Disk $DISK not found. Available disks:"
    lsblk -d -o NAME,SIZE,MODEL
    echo ""
    bold "Edit DISK= at the top of this script, or pass it as an argument:"
    bold "  sudo bash install.sh /dev/sdX"
    exit 1
fi

# allow passing disk as first argument
if [ $# -ge 1 ]; then
    DISK="$1"
fi

bold "This will ERASE $DISK and install NixOS."
echo ""
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS "$DISK"
echo ""
read -rp "Continue? [y/N] " confirm < /dev/tty
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Aborted."
    exit 0
fi

# --- clone config ---

bold "Cloning NixOS config..."
WORKDIR=$(mktemp -d)
nix-shell -p git --run "git clone $REPO $WORKDIR/nixos"
cd "$WORKDIR/nixos"

# --- partition + format ---

bold "Partitioning $DISK with disko..."
nix run github:nix-community/disko -- \
    --mode disko \
    --argstr device "$DISK" \
    ./disko.nix

# --- generate hardware config ---

bold "Generating hardware configuration..."
nixos-generate-config --no-filesystems --show-hardware-config > ./hardware-configuration.nix

# --- install ---

bold "Installing NixOS..."
nixos-install --flake ".#$FLAKE_HOST" --no-root-passwd

# --- copy config to installed system ---

bold "Copying config to /mnt/etc/nixos..."
mkdir -p /mnt/etc/nixos
rsync -a --exclude='.git' . /mnt/etc/nixos/

green ""
green "Done! Reboot into your new system:"
green "  1. reboot"
green "  2. Log in as sean (password: changeme)"
green "  3. Change your password: passwd"
green "  4. Clone dotfiles and run install.sh (see README)"
