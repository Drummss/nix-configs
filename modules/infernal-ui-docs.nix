{ config, lib, pkgs, ... }:

let
  cfg = config.services.infernal-ui-docs;
in
{
  options.services.infernal-ui-docs = {
    enable = lib.mkEnableOption "Infernal UI docs static site";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.infernal-ui-docs;
      description = "Static package containing the built Infernal UI docs site.";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/infernal-ui-docs";
      description = "Directory containing a stable symlink to the current docs build.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0755 root root -"
      "L+ ${cfg.stateDir}/site - - - - ${cfg.package}"
    ];
  };
}
