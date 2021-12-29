{ config, ... }:
with import ./_shared.nix { inherit config; };
let
  dom = config.unknin.domain;
in {
  services.nginx.virtualHosts."singularity.${dom}" = mkProxyConfig dom "http://127.0.0.1:8080/";
}
