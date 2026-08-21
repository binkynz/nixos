{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    daemon.settings = {
      ipv6 = false;
    };
  };
}
