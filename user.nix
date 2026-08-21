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
  ];
}
