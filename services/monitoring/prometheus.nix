{ ... }:
let
  prometheusPort = 7501;
in {
  services.prometheus = {
    enable = true;
    port = prometheusPort;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "cpu" "filesystem" "meminfo" "loadavg" "systemd" "zfs" ];
        port = 7502;
      };
    };
    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [
          {
            targets = [
              "localhost:7501"
            ];
          }
        ];
      }
      {
        job_name = "node";
        static_configs = [
          {
            targets = [
              "localhost:7502"
              "router:7502"
            ];
          }
        ];
      }
      {
        job_name = "cadvisor";
        static_configs = [
          {
            targets = [
              "localhost:7503"
            ];
          }
        ];
      }
    ];
  };
  
  networking.firewall.allowedTCPPorts = [ prometheusPort ];
}