{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kubectl
    pgcli
    mycli
    google-cloud-sdk
    google-cloud-sql-proxy
    google-alloydb-auth-proxy
    sops
    slack
  ];
}
