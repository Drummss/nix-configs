{ config, pkgs, lib, ... }:
let
  domain = "mail.unkn.in";
  dataDir = "/var/lib/snappymail";
in
{
  users.users.snappymail = {
    isSystemUser = true;
    group = "nginx";
    home = dataDir;
    createHome = true;
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0750 snappymail nginx - -"
  ];

  services.phpfpm.pools.snappymail = {
    user = "snappymail";
    group = "nginx";

    settings = {
      "listen.owner" = "nginx";
      "listen.group" = "nginx";

      "pm" = "dynamic";
      "pm.max_children" = 8;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;

      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };

    phpOptions = ''
      upload_max_filesize = 40M
      post_max_size = 50M
      memory_limit = 256M
    '';
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    useACMEHost = config.unknin.domain;

    root = pkgs.snappymail;

    extraConfig = ''
      index index.php;
      client_max_body_size 50M;
    '';

    locations."/" = {
      tryFiles = "$uri $uri/ /index.php?$query_string";
    };

    locations."~ \\.php$" = {
      extraConfig = ''
        include ${pkgs.nginx}/conf/fastcgi.conf;
        fastcgi_param SCRIPT_FILENAME ${pkgs.snappymail}$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;
        fastcgi_param SNAPPYMAIL_DATA_DIR ${dataDir};
        fastcgi_pass unix:${config.services.phpfpm.pools.snappymail.socket};
      '';
    };

    # Never expose SnappyMail's writable data/config area.
    locations."^~ /data" = {
      extraConfig = ''
        deny all;
        return 404;
      '';
    };
  };
}
