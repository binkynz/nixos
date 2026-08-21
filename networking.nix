{ ... }:

{
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.tailscale.enable = true;

  networking.hosts = {
    "127.0.0.1" = [
      "postgres"
      "api"
      "bigcommerce-integration"
      "bullmq-worker-sales-channel-dispatcher"
      "core-server"
      "data-ingestor"
      "data-platform-api-rs"
      "data-platform-api"
      "dataqa-api-rs"
      "dataqa-api"
      "dataqa-web"
      "elasticsearch-ingestor-rs"
      "elasticsearch-ingestor"
      "external-api-proxy"
      "file-ingestor"
      "job-completion-service"
      "kafka"
      "kafka-consensus-fitment"
      "kafka-consensus"
      "kafka-consumer-external-api"
      "kafka-consumer-gapc"
      "kafka-consumer-inventory"
      "kafka-consumer-products"
      "kafka-consumer-sales-channel-dispatcher"
      "kafka-consumer-shopify"
      "kafka-producer-gapc-imports"
      "lookup-server-cdc"
      "lookup-server"
      "migrations-background"
      "migrations-elasticsearch-analytics"
      "migrations-elasticsearch"
      "migrations-postgres"
      "migrations-scylla"
      "minio"
      "ml-server"
      "pim-web"
      "repairer-integration"
      "repairer-server"
      "sample-integration"
      "shopify-integration"
      "storefront-integration"
      "storefront-server"
      "vrm-search"
      "webhooks-notifier"
      "mailpit"
      "cassandra"
      "keyloop-integration"
      "frontend"
      "tier1-writer"
      "tier1-worker"
      "minio-proxy"
      "supply-orchestrator"
      "sellablesdb"
    ];
  };
}
