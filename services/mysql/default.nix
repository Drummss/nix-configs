{ pkgs, ... }: 
{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    dataDir = "/var/lib/mysql";
    settings.mysqld.plugin-load-add = [ "auth_ed25519.so" ];
  };

  services.mysqlBackup.enable = true;

  users.users.mysqlbackup.extraGroups = [ "backups" ];
}