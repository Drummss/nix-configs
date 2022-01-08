# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }: let
  m1cr0manConfigs = import ../../lib/m1cr0man-configs.nix;
in {
  imports = [ # Include the results of the hardware scan.
    ./config
    ./users.nix
    ./hardware-configuration.nix
    ../../common
    ../../services/bots
    ../../services/mysql
    ../../services/nginx # equivalent to appending /default.nix
    ../../services/ssh.nix
    ../../services/pterodactyl/panel
    ../../services/pterodactyl/wings
    "${m1cr0manConfigs}/common/sysconfig.nix"
  ];

  system.stateVersion = "22.05";

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    devices = [ "/dev/nvme0n1" ];
  };

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

  time.timeZone = lib.mkForce "Etc/UTC";

  environment.systemPackages = [ pkgs.nixos-option ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
  };

  # Enable KSM because the MC servers share a lot of data
  hardware.ksm.enable = true;

  pterodactyl-wings = {
    enable = true;
    panelUrl = "https://pterodactyl.unkn.in";
    nodeId = 1;
    apiPort = 7005;
    sftpPort = 7006;
    token = "uNowv6c7zJw0JfydSvU2KuWLd5XjVEbsNFR91zNmGGDhQ9GO";
    extraConfig.api.ssl = {
      cert = config.security.acme.certs."${config.unknin.domain}".directory + "/cert.pem";
      key = config.security.acme.certs."${config.unknin.domain}".directory + "/key.pem";
    };
  };
}
