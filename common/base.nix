{ pkgs, config, lib, ... }:
{

  boot.kernelParams = [
    "boot.shell_on_fail"
    "ip=dhcp"
  ];

  networking.domain = "unkn.in";

  time.timeZone = "Etc/UTC";
  i18n.defaultLocale = "en_IE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  environment.systemPackages = with pkgs; [
    wget vim git screen zstd git-crypt htop
  ];

  # Enable accounting so systemd-cgtop can show IO load
  #systemd.enableCgroupAccounting = true;
}
