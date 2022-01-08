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
    ./network-configuration.nix
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

  time.timeZone = lib.mkForce "Etc/UTC";

  environment.systemPackages = [ pkgs.nixos-option ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
  };

  # Enable KSM because the MC servers share a lot of data
  hardware.ksm.enable = true;
}
