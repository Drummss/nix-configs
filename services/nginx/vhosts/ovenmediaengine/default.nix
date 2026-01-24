{ lib, config, ... }:
with import ../_shared.nix { inherit config; };
let
  dom = config.unknin.domain;
in {
  services.nginx.virtualHosts."stream.${dom}" = {
    forceSSL = true;
    useACMEHost = dom;

    locations."/" = {
      root = ./html;
      index = "index.html";
      #basicAuthFile = /var/secrets/streamunkn/.htpasswd;
      basicAuth = {
        aya = "ayacutie";
      };
    };
    locations."/viewers" = {
      proxyPass = "http://127.0.0.1:7602/v1/stats/current/vhosts/default";
      extraConfig = ''
        proxy_set_header authorization "Basic dGVzdGluZ1Rva2Vu";
      '';
    };
    locations."~ ^/api/(.*)$" = {
      priority = 999;
      proxyPass = "http://127.0.0.1:7602/$1";
    };
    locations."~ ^/ws/480/(.*)$" = {
      priority = 999;
      proxyWebsockets = true;
      proxyPass = "http://127.0.0.1:7601/app/$1_quality";
    };
    locations."~ ^/ws/720/(.*)$" = {
      priority = 999;
      proxyWebsockets = true;
      proxyPass = "http://127.0.0.1:7601/app/$1_hd";
    };
    locations."~ ^/ws/source/(.*)$" = {
      priority = 999;
      proxyWebsockets = true;
      proxyPass = "http://127.0.0.1:7601/app/$1_source";
    };
  };
}
