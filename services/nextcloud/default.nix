{ lib, config, pkgs, ... }:
let
  rootDom = config.unknin.domain;
  domain = "nextcloud.${rootDom}";
in {

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33;
    phpPackage = pkgs.php85;
    datadir = "/var/lib/nextcloud";
    hostName = domain;
    https = true;
    maxUploadSize = "4100M";
    appstoreEnable = true;
    autoUpdateApps.enable = true;
    autoUpdateApps.startAt = "05:00:00";
    enableImagemagick = true;
    config = {
      adminpassFile = "/var/secrets/nextcloud/adminpass.txt";
      dbtype = "pgsql";
      dbhost = "127.0.0.1";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbpassFile = "/var/secrets/nextcloud/database-pass.txt";
    };
    settings = {
      default_phone_region = "UK";
      log_type = "file";
      maintenance_window_start = 1;
    };
    phpOptions = {
      "opcache.save_comments" = 60;
      "opcache.revalidate_freq" = 60;
      "opcache.interned_strings_buffer" = 32;
      "opcache.validate_timestamps" = 0;
      "redis.session.locking_enabled" = 1;
      "redis.session.lock_retries" = -1;
      "redis.session.lock_wait_time" = 10000;
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
  };
}
