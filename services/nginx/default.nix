{ ... }:
{
  imports = [
    ./certs.nix
    ./vhosts/singularity.nix
    ./vhosts/pterodactyl.nix
    ./vhosts/verdaccio.nix
  ];

  services.nginx = {
    enable = true;
    enableReload = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
