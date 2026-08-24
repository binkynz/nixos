{ pkgs, inputs, ... }:

{
  users.users.sean = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [ "docker" "wheel" "networkmanager" ];
    shell = pkgs.fish;
    createHome = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    google-chrome
    just
    lazygit
    atuin
    stow
    nerd-fonts.caskaydia-mono
    pass-wayland
    gnupg
    pinentry-curses
    passff-host
    git-crypt
    stylua
    lspmux
    stremio-linux-shell
  ];

  systemd.user.services.lsp-mux = {
    description = "LSP multiplex server";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = 5;
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/socket";
      ExecStart = "${pkgs.lspmux}/bin/lspmux server";
      Environment = "CARGO_TARGET_DIR=target/rust-analyzer PATH=/run/current-system/sw/bin";
    };
  };

  systemd.user.services.cargo-clean = {
    description = "Clean old Cargo build artifacts";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "%h/.cargo/bin/cargo-clean-all --yes --keep-days 7 --keep-size 100MB %h/dev";
    };
  };

  systemd.user.timers.cargo-clean = {
    description = "Weekly cleanup of old Cargo build artifacts";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
