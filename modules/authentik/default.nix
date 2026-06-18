{ config, pkgs, lib, ... }:

let
  domain = "auth.unkn.in";
in
{
  services.authentik = {
    enable = true;
    environmentFile = "/var/lib/authentik/authentik.env";
    createDatabase = false;

    settings = {
      email = {
        host = "smtp.unkn.in";
        port = 587;
        username = "auth@unkn.in";
        use_tls = true;
        use_ssl = false;
        from = "auth@unkn.in";
      };

      avatars = "initials";
      disable_startup_analytics = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/authentik 0750 root root -"
    "d /var/lib/authentik/backups 0750 root root -"
  ];

  services.postgresql = {
    ensureDatabases = [
      "authentik"
    ];

    ensureUsers = [
      {
        name = "authentik";
        ensureDBOwnership = true;
      }
    ];
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    useACMEHost = config.unknin.domain;

    locations."/" = {
      proxyPass = "https://127.0.0.1:9443";
      proxyWebsockets = true;

      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port 443;

        proxy_ssl_verify off;
      '';
    };
  };
}