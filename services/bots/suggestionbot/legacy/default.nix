{ pkgs, ... }:
{
  # users.groups = {
  #   suggestionbot = {};
  # };

  # users.users.suggestionbot = {
  #   isSystemUser = true;
  #   group = "suggestionbot";
  #   home = "/dev/null";
  # };

  systemd.services.suggestionbot = {
    path = [ pkgs.nodejs ];
    script = ''
      node ${pkg}/index.js
    '';
    serviceConfig = {
      EnvironmentFile = "/var/secrets/suggestionbot.env";
      DynamicUser = true;
    };
  };
}