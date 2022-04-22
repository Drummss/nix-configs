{ config, ... }:
with import ./_shared.nix { inherit config; };
let
  dom = config.unknin.domain;
in {
  services.nginx.virtualHosts."matrix.${dom}" = mkProxyConfig dom "http://127.0.0.1:7100/";
  services.nginx.virtualHosts."element.${dom}" = mkProxyConfig dom "http://127.0.0.1:7101/";
}
