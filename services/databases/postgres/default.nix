{ pkgs, lib, ... }: 
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    dataDir = "/var/lib/postgres";
    settings = {
      listen_addresses = lib.mkForce "*";
    };
    authentication = ''
      local     all       postgres    peer
      local     all       all         md5

      host      all       all         0.0.0.0/0       md5
    '';
  };

  services.postgresqlBackup.enable = true;

  users.users.postgres.extraGroups = [ "backups" ];

  networking.firewall.allowedTCPPorts = [ 5432 ];
}