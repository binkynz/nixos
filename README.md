# nixos

Personal NixOS configuration. Hyprland desktop with Fish, PipeWire, Docker, Bluetooth, and Zen Browser.

## What You Get

- **Hyprland** + GDM + PipeWire audio + Bluetooth
- **Fish** shell with Atuin, Lazygit, Neovim, fzf, fd, bat, eza, zoxide, delta
- **Dev tooling** — gcc, clang, mold, rustup, Go, Node.js, Python (uv + pyright), direnv + nix-direnv
- **Docker** + docker-compose
- **pass** (password-store) + GPG + passff for Zen/Firefox
- **Zen Browser** (via flake input)
- **GPU acceleration** + xdg-desktop-portal-hyprland
- Declarative disk partitioning with **disko**

## Fresh Install

Boot the [NixOS minimal ISO](https://nixos.org/download/) from a USB drive, connect to the network, then:

```sh
# connect to wifi (skip if on ethernet)
sudo nmcli dev wifi connect "YourSSID" password "YourPassword"

# run the installer
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/binkynz/nixos/main/install.sh)"
```

The script partitions the disk (512M EFI + 8G swap + ext4 root), generates a hardware config, and runs `nixos-install`.

To use a different disk:

```sh
sudo bash install.sh /dev/sdX
```

## Post-Install

After rebooting, log in as `sean` (password: `changeme`):

```sh
# change your password
passwd

# generate an SSH key
ssh-keygen -t ed25519
# add ~/.ssh/id_ed25519.pub to GitHub

# import GPG key (from USB or another machine)
gpg --import /path/to/gpg-key.bak
gpg --edit-key seancregister@gmail.com   # trust > 5 (ultimate) > quit

# clone password store
git clone git@github.com:binkynz/pass.git ~/.password-store

# clone and decrypt dotfiles
git clone git@github.com:binkynz/dotfiles.git ~/dotfiles
cd ~/dotfiles
pass show keys/dotfiles | base64 -d > ~/dotfiles.key
git-crypt unlock ~/dotfiles.key && rm ~/dotfiles.key
./install.sh core
./install.sh desktop
```

## Day-to-Day

```sh
# rebuild after editing config
sudo nixos-rebuild switch --flake /etc/nixos#desktop

# update all flake inputs
cd /etc/nixos
sudo nix flake update
sudo nixos-rebuild switch --flake .#desktop

# garbage collect old generations
sudo nix-collect-garbage -d
```

## Structure

```
flake.nix                 # inputs + machine definition
configuration.nix         # base system: networking, nix, boot, dev tooling
desktop.nix               # Hyprland, PipeWire, GPU, Bluetooth, portal
docker.nix                # Docker + docker-compose
user.nix                  # sean user + personal packages
disko.nix                 # disk partitioning (EFI + swap + ext4)
hardware-configuration.nix  # generated per-machine
install.sh                # bootstrap from NixOS live ISO
```

## Adding Packages

User-level packages go in `user.nix`. System-level in `configuration.nix`. Desktop/Wayland tools in `desktop.nix`. Then rebuild:

```sh
sudo nixos-rebuild switch --flake /etc/nixos#desktop
```
