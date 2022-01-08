{ config, lib, pkgs, ... }:
let 
  cfg = config.pterodactyl-wings;
  package = pkgs.callPackage ../../../packages/pterodactyl-wings {};

  baseConfig = {
    remote = cfg.panelUrl; 
  };

  extraConfigYaml = pkgs.writeText "wings-config.yml" (builtins.toJSON (baseConfig // cfg.extraConfig));
in
{
  options.pterodactyl-wings = with lib; {
    enable = mkEnableOption "pterodactyl Wings daemon";
    panelUrl = mkOption {
      default = "http://localhost:7000";
      description = "URL for Pterodactyl Panel that will manage this node.";
      type = types.str;
    };
    nodeId = mkOption {
      description = "The ID for the Wings node.";
      type = types.int;
    };
    token = mkOption {
      description = "The token for the Wings node.";
      type = types.str;
    };
    apiPort = mkOption {
      description = "The API port for the Wings node server.";
      type = types.int;
    };
    sftpPort = mkOption {
      description = "The SFTP port for the Wings node server.";
      type = types.int;
    };
    extraConfig = mkOption {
      default = {};
      description = ''
        Attrset of extra configurations for the Wings node service.
        https://pterodactyl.io/wings/1.0/installing.html#configure
      '';
      type = types.attrs;
    };
  };

  config = lib.mkIf (cfg.enable) {
    systemd.services.pterodactyl-wings = {
      requires = [ "local-fs.target" "network-online.target" ];
      after = [ "local-fs.target" "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ package pkgs.yq-go ];
      preStart = with builtins; ''
        if [ ! -e config.orig.yml ]; then
          if ! wings configure --config config.orig.yml --panel-url ${cfg.panelUrl} --token ${cfg.token} --node ${toString cfg.nodeId}; then
            echo "Failed to fetch configuration from Pterodactyl Panel" >&2
            exit 1
          fi
        fi
        yq ea '. as $item ireduce ({}; . * $item )' config.orig.yml ${extraConfigYaml} > config.yml
      '';
      script = ''
        wings --config config.yml
      '';
      startLimitIntervalSec = 180;
      startLimitBurst = 30;
      serviceConfig = {
        WorkingDirectory = "/var/lib/pterodactyl/wings";
        StateDirectory = "pterodactyl/wings";
        RuntimeDirectory = "wings";
        LimitNOFILE = 4096;
        PIDFile = "/var/run/wings/daemon.pid";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.apiPort cfg.sftpPort ];
  };
}
