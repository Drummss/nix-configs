{ ... }:
{
  imports = [
    ./certs.nix
    ./vhosts/singularity.nix
  ];

  services.nginx = {
    enable = true;
    enableReload = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
