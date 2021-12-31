{ pkgs, ... }: 
{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    dataDir = "/var/lib/mysql";
  };

  services.mysqlBackup.enable = true;
}