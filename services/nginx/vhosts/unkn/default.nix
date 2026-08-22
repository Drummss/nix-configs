{ lib, config, ... }:
with import ../_shared.nix { inherit config; };
let
  dom = config.unknin.domain;
in {
  services.nginx.virtualHosts."${dom}" = {
    forceSSL = true;
    useACMEHost = dom;

    locations."/" = {
      root = ./html;
      index = "index.html";
    };
  };
}
