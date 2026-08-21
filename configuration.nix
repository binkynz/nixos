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
    pkg-config
    openssl.dev
    zlib.dev
    zstd.dev
    go
    gopls
    nodejs
    pnpm
    uv
    pyright
  ];

  i18n.defaultLocale = "en_NZ.UTF-8";
  time.timeZone = "Europe/London";

  nixpkgs.config.allowUnfree = true;

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

  systemd.tmpfiles.rules = [
    "L+ /usr/bin/mold  - - - - ${pkgs.mold}/bin/mold"
    "L+ /usr/bin/bash  - - - - ${pkgs.bash}/bin/bash"
    "L+ /usr/bin/env   - - - - ${pkgs.coreutils}/bin/env"
    "L+ /bin/bash      - - - - ${pkgs.bash}/bin/bash"
  ];

  environment.variables = {
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.zlib.dev}/lib/pkgconfig";
  };

  documentation.man.enable = true;

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

  services.earlyoom.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.05";
}
