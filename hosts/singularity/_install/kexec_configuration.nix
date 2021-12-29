let
  external-mac = "a8:a1:59:0f:73:21";
  ext-if = "eth0";
  external-ip = "49.12.133.196";
  external-gw = "49.12.133.193";
  external-netmask = 26;
in {
  # rename the external interface based on the MAC of the interface
  services.udev.extraRules = ''SUBSYSTEM=="net", ATTR{address}=="${external-mac}", NAME="${ext-if}"'';
  networking = {
    interfaces."${ext-if}" = {
      ipv4.addresses = [{
        address = external-ip;
        prefixLength = external-netmask;
      }];
    };
    defaultGateway = external-gw;
  };
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs = {
    enableUnstable = true;
    forceImportRoot = true;
    forceImportAll = false;
  };
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINV2JF6dDjXlmUgVlzk7y5VwXx4r5+1rd95e+lU4VayA lucas@blueboi"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/wSzCVLnKF7TVUvPBjRmlurMgxKoDajYqeFKWy8kJH root@gelandewagen"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJL8j3uGq7UuFBvFrJPAzgkiaushzYnjyHYQKeQ48fgd Drumsy"
  ];
}
