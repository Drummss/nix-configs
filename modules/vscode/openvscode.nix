{ config, pkgs, ... }:

let
  username = "drummss";
in
{
  environment.systemPackages = with pkgs; [
    openvscode-server
  ];

  systemd.services.openvscode-server = {
    description = "OpenVSCode Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = username;
      Group = "users";
      WorkingDirectory = "/home/${username}";

      ExecStart = ''
        ${pkgs.openvscode-server}/bin/openvscode-server \
          --host 127.0.0.1 \
          --port 3000 \
          /home/${username}
      '';

      Restart = "always";
      RestartSec = 5;
    };
  };
}
