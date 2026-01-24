{ config, ... }:
let
  grafanaPort = 7500;
in {
  services.grafana = {
    enable = true;
    dataDir = "/var/lib/grafana";
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = grafanaPort;
      };
      security = {
        admin_user = "drummss";
        admin_password = "$__file{/var/secrets/grafana/admin-password.txt}";
        secret_key = "$__file{/var/secrets/grafana/secret-key.txt}";
      };
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          url = "http://127.0.0.1:7501/";
          type = "prometheus";
          isDefault = true;
        }
      ];
    };
  };
}