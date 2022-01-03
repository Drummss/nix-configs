{ pkgs, lib, ... }:
{
  users.groups = {
    drumsy = {};
    lucas = {};
    backups = {};
  };

  users.users = {
    drumsy = {
      name = "drumsy";
      group = "drumsy";
      home = "/home/drumsy";
      shell = pkgs.bashInteractive;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAege5ZduOXnBbhJ5V3TXVRTLkcQtVedwVbAL9cR5+g/ drumsy@singularity"
      ];
    };
    lucas = {
      name = "lucas";
      group = "lucas";
      home = "/home/lucas";
      shell = pkgs.bashInteractive;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/wSzCVLnKF7TVUvPBjRmlurMgxKoDajYqeFKWy8kJH root@gelandewagen"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINV2JF6dDjXlmUgVlzk7y5VwXx4r5+1rd95e+lU4VayA lucas@blueboi"
      ];
    };
  };
}