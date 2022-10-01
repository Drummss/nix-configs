{ config, pkgs, ... }:
let
  rootDom = config.unknin.domain;
  domain = "nextcloud.${rootDom}";
in {

  services.nextcloud = {
    enable = true;
    datadir = "/var/lib/nextcloud";
    hostName = domain;
    https = true;
    config = {
      adminpassFile = "/var/secrets/nextcloud/adminpass.txt";
      dbtype = "pgsql";
      dbhost = "127.0.0.1";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbpassFile = "/var/secrets/nextcloud/database-pass.txt";
    };
    # extraApps = {
    #   registration = pkgs.fetchNextcloudApp {
    #     name = "registration";
    #     sha256 = "RpRr86IPmDLbpkXT0wdWNJxpvgRxBIKxxbF3/KS7QBg=";
    #     url = "https://github.com/nextcloud/registration/archive/refs/tags/v1.4.0.tar.gz";
    #     version = "1.4.0";

    #   };
    # };
  };

  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = rootDom;

    locations."/" = {
      priority = 900;
      extraConfig = ''
        rewrite ^ /index.php;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;
        proxy_buffering off;
        proxy_request_buffering off;
      '';
    };

    locations."/.well-known/carddav" = {
      return = "301 $scheme://$host/remote.php/dav";
    };

    locations."/.well-known/caldav" = {
      return = "301 $scheme://$host/remote.php/dav";
    };
  };
}