{ pkgs, config, ... }:
let
  serviceConfig = {
    after = [ "zfs.target" ];
    restartIfChanged = false;
    path = [ config.boot.zfs.package ];
    serviceConfig.Type = "oneshot";
  };

  # This script will iterate through all pools on a server
  # and prompt the user to unlock them.
  # The user can then run "pkill zfs" to resume the boot process.
  unlockerScript = pkgs.writeShellScript "unlock-zfs.sh" ''
    zpool import -a
    zfs load-key -a
  '';
in {
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs = {
    package = pkgs.zfs_unstable;
    forceImportRoot = true;
    forceImportAll = false;
  };
  boot.extraModprobeConfig = ''
    options zfs zfs_scrub_min_time_ms=50
    options zfs zfs_arc_max=4294967296
  '';

  # Enable shell during boot for ZFS key prompt
  boot.initrd.extraFiles."unlock-zfs.sh".source = unlockerScript;
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 6416;
      authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
      hostKeys = [
        "/var/secrets/ssh_initrd_host_ed25519_key"
      ];
    };
  };

  # Use DHCP during the initrd, then undo the config before stage 2 boot
  boot.initrd.postMountCommands = ''
    ip a flush eth0
    ip l set eth0 down
  '';

  # Incremental scrubbing to avoid drive murder
  systemd.services.zfs-scrub = serviceConfig // {
    description = "Start ZFS incremental scrub";
    script = "zpool scrub $(zpool list -Ho name)";
  };

  systemd.services.zfs-scrub-stop = serviceConfig // {
    description = "Stop ZFS incremental scrub";
    script = "zpool scrub -p $(zpool list -Ho name) || true";
  };

  systemd.timers.zfs-scrub = {
    description = "Start ZFS incremental scrub";
    wantedBy = [ "timers.target" ];
    after = [ "zfs.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 05:00:00";
      RandomizedDelaySec = 60;
      Persistent = false;
    };
  };

  # Runs 30 minutes after the above, or on next boot
  systemd.timers.zfs-scrub-stop = {
    description = "Stop ZFS incremental scrub";
    wantedBy = [ "timers.target" ];
    after = [ "zfs.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 05:30:00";
      RandomizedDelaySec = 60;
      Persistent = true;
    };
  };
}
