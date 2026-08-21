{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pavucontrol
    foot
    grim
    slurp
    wl-clipboard
    mako
    rofi
    waybar
    brightnessctl
    playerctl
    hyprlock
    hypridle
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=true
  '';

  environment.etc."xdg/gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=true
  '';

  qt.enable = true;
  qt.style = "adwaita-dark";

  hardware.graphics.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.hyprland.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  services.displayManager.gdm.enable = true;

  services.printing.enable = true;
}
