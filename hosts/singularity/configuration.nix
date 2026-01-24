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
    ../../services/audiobookshelf
    ../../services/bots
    ../../services/databases
    #../../services/gh-runner
    ../../services/monitoring
    #../../services/nextcloud
    ../../services/nginx # equivalent to appending /default.nix
    ../../services/ssh.nix
    ../../services/pterodactyl/panel
    ../../services/pterodactyl/wings
    # "${m1cr0manConfigs}/common/sysconfig.nix"
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];

  system.stateVersion = "22.05";

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    devices = [ "/dev/nvme0n1" ];
  };

  time.timeZone = lib.mkForce "Etc/UTC";

  environment.systemPackages = [
    pkgs.arion 
    pkgs.nixos-option
    pkgs.jetbrains-toolbox 
  ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1u"
    "nodejs-14.21.3"
    "nodejs-16.20.1"
  ];

  virtualisation.oci-containers.backend = "docker";

  services.vscode-server.enable = true;
  services.vscode-server.enableFHS = true;
  services.vscode-server.installPath = "$HOME/.vscode-server";

  # Enable KSM because the MC servers share a lot of data
  hardware.ksm.enable = true;


  ### TEMPORARY PORT FROM microman-configs

  ## sysconfigs.nix
  # Use DHCP during the initrd, then undo the config before stage 2 boot
  boot.initrd.postMountCommands = ''
    ip a flush eth0
    ip l set eth0 down
  '';

  # Fix vscode-server node binary on login
  environment.shellInit = let
    node = pkgs.nodejs_24;
    findutils = pkgs.findutils;
  in ''
    umask 0027
    if test -e ~/.vscode-server; then
      ${findutils}/bin/find $HOME/.vscode-server -type f -name node \( -execdir rm '{}' \; -and -execdir ln -s '${node}/bin/node' '{}' \; \)
    fi
  '';

  # Enable rsyslog
  services.rsyslogd.enable = true;
  services.rsyslogd.extraConfig = "*.* @127.0.0.1:6514;RSYSLOG_SyslogProtocol23Format";

  # Rotate logs with cron
  services.cron.enable = true;
  services.cron.systemCronJobs = [
    "0 4 * * * journalctl --vacuum-time=7d"
  ];
}
