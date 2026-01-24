{ config, lib, ... }:
with import ./_shared.nix { inherit config; };
let
  dom = config.unknin.domain;
in {
  services.nginx.virtualHosts."astral.${dom}" = lib.mkMerge [
    (mkProxyConfig dom "http://49.12.133.196:30000/")
    {
      locations."/" = {
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_redirect off;
          proxy_buffering off;
          proxy_request_buffering off;
        '';
      };
    }
  ];

  services.nginx.virtualHosts."novaeterrae.${dom}" = lib.mkMerge [
    (mkProxyConfig dom "http://49.12.133.196:30001/")
    {
      locations."/" = {
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
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
