{ config, ... }:
with import ./_shared.nix { inherit config; };
let
  dom = "pandabot.one";
in {
  services.nginx.virtualHosts."${dom}" = mkProxyConfig dom "http://127.0.0.1:7801/";
  services.nginx.virtualHosts."www.${dom}" = mkProxyConfig dom "http://127.0.0.1:7801/";
}
