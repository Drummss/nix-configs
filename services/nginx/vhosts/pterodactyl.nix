{ lib, config, ... }:
with import ./_shared.nix { inherit config; };
let
  dom = config.unknin.domain;
in {
  services.nginx.virtualHosts."pterodactyl.${dom}" = lib.mkMerge [
    (mkProxyConfig dom "http://127.0.0.1:7000/")
    {
      locations."/" = {
        extraConfig = ''
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_redirect off;
          proxy_buffering off;
          proxy_request_buffering off;
        '';
      };
    }
  ];
}
