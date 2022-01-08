{ ... }:
{
  boot.initrd.network.postCommands = ''
    pkill udhcpc
    ip a flush dev eth0
    ip a add 49.12.133.196/26 dev eth0
    ip route add default via 49.12.133.193 dev eth0
    ip l set eth0 up
  '';

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
    hosts = {
      "127.0.0.1" = [ "singularity.unkn.in" ];
    };
  };
}