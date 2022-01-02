{ config, lib, ... }:
let
  httpPort = 7000;
  redisPort = 7001;
  dockerHostIp = "host.docker.internal";
  dbPassword = (builtins.readFile /var/secrets/pterodactyl/pterodactyl-database-password);
in
{
  users.groups.pterodactyl = {
    gid = 2050;
  };

  users.users.pterodactyl = {
    uid = 2050;
    isSystemUser = true;
    home = "/var/lib/pterodactyl";
    createHome = true;
    group = "pterodactyl";
  };

  services.mysql.ensureDatabases = [ "pterodactyl_panel" ];

  systemd.services.pterodactyl-create-user = {
    serviceConfig.Type = "oneshot";
    path = [ config.services.mysql.package ];
    wantedBy = [ "multi-user.target" ];
    requires = [ "mysql.service" ];
    after = [ "mysql.service" ];
    script = ''
      (
        echo "CREATE USER IF NOT EXISTS 'pterodactyl'@'%' IDENTIFIED BY '${dbPassword}';"
        echo "GRANT ALL PRIVILEGES ON pterodactyl_panel.* TO 'pterodactyl'@'%';"
      ) | mysql -N
    '';
  }; 

  # Redis Server
  services.redis.servers."pterodactyl" = {
    enable = true;
    port = redisPort;
    requirePassFile = "/var/secrets/pterodactyl-redis-password";
    user = "pterodactyl";
    bind = "0.0.0.0";
    settings = {
      maxmemory = "2gb";
      maxmemory-policy = "volatile-lru";
      dir = lib.mkForce "/var/lib/pterodactyl/redis";
      requirepass = "pterodactyl";
    };
  };

  systemd.services."redis-pterodactyl".serviceConfig.StateDirectory = 
    lib.mkForce "pterodactyl/redis";


  # Pterodactyl Panel
  virtualisation.oci-containers.containers."pterodactyl" = {
    image = "ghcr.io/pterodactyl/panel:latest";
    volumes = [
      "/var/lib/pterodactyl/app:/app/var/"
      "/var/lib/pterodactyl/logs/:/app/storage/logs"
    ];
    ports = with builtins; [
      "${toString httpPort}:80"
    ];
    environment = with builtins; {
      APP_URL = "http://49.12.133.196/";
      APP_TIMEZONE = "UTC";
      DB_HOST = dockerHostIp;
      DB_PORT = "3306";
      DB_DATABASE = "pterodactyl_panel";
      DB_USERNAME = "pterodactyl";
      DB_PASSWORD = dbPassword;
      CACHE_DRIVER = "redis";
      SESSION_DRIVER = "redis";
      QUEUE_DRIVER = "redis";
      REDIS_HOST = dockerHostIp;
      REDIS_PORT = "${toString redisPort}";
      REDIS_PASSWORD = "pterodactyl";
    };
    extraOptions = [
      "--add-host=host.docker.internal:host-gateway"
    ];
  };

  # Forward ports on the docker network
  networking.firewall.interfaces.docker0.allowedTCPPorts = [ 3306 redisPort ];
}