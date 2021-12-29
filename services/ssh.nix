{
  services.openssh = {
    enable = true;
    gatewayPorts = "yes";
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAege5ZduOXnBbhJ5V3TXVRTLkcQtVedwVbAL9cR5+g/ drumsy@singularity"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/wSzCVLnKF7TVUvPBjRmlurMgxKoDajYqeFKWy8kJH root@gelandewagen"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINV2JF6dDjXlmUgVlzk7y5VwXx4r5+1rd95e+lU4VayA lucas@blueboi"
  ];
}
