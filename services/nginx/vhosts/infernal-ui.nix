{ lib, config, ... }:
with import ./_shared.nix { inherit config; };
let
  dom = "infernal-ui.com";
  cfg = config.services.infernal-ui-docs;
in {
  services.nginx.virtualHosts."${dom}" = {
    useACMEHost = dom;
    forceSSL = true;

    root = cfg.package;

    extraConfig = ''
      try_files $uri $uri/ /index.html;
    '';
  };
}
