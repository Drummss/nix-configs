{ config, lib, pkgs, ... }:

let
  cfg = config.services.pelican-wings;
in
{
  options.services.pelican-wings = {
    enable = lib.mkEnableOption "Pelican Wings daemon";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.pelican-wings;
      description = "The pelican-wings package to run.";
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/pelican/config.yml";
      description = "Path to the Wings config file.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra arguments passed to Wings.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = lib.mkDefault true;

    users.groups.pelican = {
      gid = 2051;
    };

    users.users.pelican = {
      uid = 2051;
      isSystemUser = true;
      group = "pelican";
      extraGroups = [ "docker" ];
    };

    systemd.services.pelican-wings = {
      description = "Pelican Wings Daemon";
      wantedBy = [ "multi-user.target" ];

      after = [ "local-fs.target" "network-online.target" "docker.service" ];
      requires = [ "local-fs.target" "network-online.target" "docker.service" ];
      
      serviceConfig = {
        WorkingDirectory = "/var/lib/pelican";
        PIDFile = "/var/run/wings/daemon.pid";
        RuntimeDirectory = "wings";
        LogDirectory = "pelican";
        StateDirectory = "pelican";
        ExecStart = ''
          ${cfg.package}/bin/wings \
            --config ${cfg.configFile} \
            ${lib.escapeShellArgs cfg.extraArgs}
        '';

        Restart = "on-failure";
        RestartSec = "5s";
        LimitNOFILE = 4096;
      };
    };
  };
}
