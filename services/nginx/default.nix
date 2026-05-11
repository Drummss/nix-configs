{ ... }:
{
  imports = [
    ./certs.nix
    ./vhosts/ovenmediaengine
    ./vhosts/foundry.nix
    #./vhosts/matrix.nix
    ./vhosts/grafana.nix
    ./vhosts/singularity.nix
    #./vhosts/pandabot.nix
    ./vhosts/pelican.nix
    #./vhosts/pterodactyl.nix
    ./vhosts/verdaccio.nix
  ];

  services.nginx = {
    enable = true;
    enableReload = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
