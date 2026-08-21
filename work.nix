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

  systemd.user.services.alloydb-auth-proxy = {
    description = "AlloyDB Auth Proxy";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = builtins.concatStringsSep " " [
        "${pkgs.google-alloydb-auth-proxy}/bin/alloydb-auth-proxy"
        "--auto-iam-authn"
        "--public-ip"
        "projects/prod-eu-6396/locations/europe-west3/clusters/data-prod/instances/read-pool?port=9661"
        "projects/prod-eu-6396/locations/europe-west3/clusters/platform-prod/instances/primary?port=9662"
      ];
    };
  };

  systemd.user.services.alloydb-pw-proxy = {
    description = "AlloyDB Auth Proxy (password auth)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = builtins.concatStringsSep " " [
        "${pkgs.google-alloydb-auth-proxy}/bin/alloydb-auth-proxy"
        "--public-ip"
        "projects/prod-eu-6396/locations/europe-west3/clusters/data-prod/instances/primary?port=9660"
        "projects/prod-eu-6396/locations/europe-west3/clusters/sellablesdb/instances/sellablesdb-prod?port=9663"
      ];
    };
  };

  systemd.user.services.cloud-sql-proxy = {
    description = "Cloud SQL Auth Proxy";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = 5;
      ExecStart = builtins.concatStringsSep " " [
        "${pkgs.google-cloud-sql-proxy}/bin/cloud-sql-proxy"
        "--auto-iam-authn"
        "--port" "9654"
        "prod-eu-6396:europe-west3:partly-postgres-read-replica"
        "prod-eu-6396:europe-west3:discovery-prod"
        "prod-eu-6396:europe-west3:tooling-db-ebcc"
        "partly-staging-au:australia-southeast2:staging-postgres"
      ];
    };
  };
}
