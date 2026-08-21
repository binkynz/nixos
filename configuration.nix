{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    wget
    bottom
    dust
    file
    jq
    git
    ripgrep
    htop
    neovim
    tmux
    tree
    unzip
    zip
    fzf
    fd
    bat
    eza
    zoxide
    delta
    tree-sitter
    poppler-utils
    gcc
    clang
    mold
    cmake
    gnumake
    rustup
    go
    gopls
    nodejs
    pnpm
    uv
    pyright
  ];

  networking.hostName = "desktop";
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  i18n.defaultLocale = "en_NZ.UTF-8";
  time.timeZone = "Pacific/Auckland";

  nixpkgs.config.allowUnfree = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.tailscale.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  programs.fish.enable = true;
  programs.nix-ld.enable = true;
  programs.git.enable = true;
  programs.ssh.startAgent = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  documentation.man.enable = true;

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

  services.earlyoom.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.05";
}
