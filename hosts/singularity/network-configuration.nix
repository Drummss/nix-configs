{ pkgs, ... }:
{
  # Required for ZFS unlocking
  boot.initrd.systemd = {
    network = {
      enable = true;
      networks."20-eth0" = {
        enable = true;
        name = "eth0";
        DHCP = "no";
        address = [
          "49.12.133.196/26"
          "2a01:4f8:242:4a1f::/64"
        ];
        routes = [{Gateway = "49.12.133.193";}];
      };
    };
  };

  networking = {
    hostId = "86d50764";
    hostName = "singularity";
    useDHCP = false;
    
    usePredictableInterfaceNames = false;
    interfaces.eth0.ipv4.addresses = [{
      address = "49.12.133.196";
      prefixLength = 26;
    }];
    interfaces.eth0.ipv6.addresses = [{
      address = "2a01:4f8:242:4a1f::1";
      prefixLength = 64;
    }];
    defaultGateway = "49.12.133.193";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    nameservers = [ "8.8.8.8" "1.1.1.1" ];
  };
}
