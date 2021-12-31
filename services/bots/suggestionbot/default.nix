{ config, ... }:
{
  users.groups = {
    sugbot = {
      gid = 991;
    };
  };

  users.users.sugbot = {
    uid = 996;
    isSystemUser = true;
    group = "sugbot";
    home = "/var/lib/suggestionbot";
    createHome = true;
  };

  virtualisation.oci-containers.containers.suggestionbot = {
    image = "suggestionbot:2.0.0";
    volumes = [
      "/var/lib/suggestionbot/suggestionbot.sqlite:/usr/app/suggestionbot.sqlite"
    ];
    environmentFiles = [
      "/var/secrets/suggestionbot.env"
    ];
    # user = with builtins; "${toString config.users.users.sugbot.uid}:${toString config.users.groups.sugbot.gid}";
  };
}