{ config, ... }:
with import ./_shared.nix { inherit config; };
let
  dom = config.unknin.domain;
in {
  services.nginx.virtualHosts."anteres.${dom}" = mkProxyConfig dom "http://anteres.ddns.net";
  services.nginx.virtualHosts."plex.${dom}" = {
    locations."/" = {
      proxyPass = "http://anteres.ddns.net:32401";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $proxy_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
    useACMEHost = dom;
    forceSSL = true;
  };
}
