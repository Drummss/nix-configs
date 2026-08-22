{ lib, config, ... }:
with import ./_shared.nix { inherit config; };
let
  dom = config.unknin.domain;
in {
  services.nginx.virtualHosts."wings.singularity.${dom}" = lib.mkMerge [
  (mkProxyConfig "singularity.${dom}" "http://127.0.0.1:7000/")
  {
    extraConfig = ''
      client_max_body_size 10G;
    '';

    locations."/" = {
      extraConfig = ''
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;
        proxy_buffering off;
        proxy_request_buffering off;

        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
      '';
    };
  }
];
}
