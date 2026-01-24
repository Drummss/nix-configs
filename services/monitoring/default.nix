{ ... }:
{
  imports = [
    ./grafana.nix
    ./prometheus.nix
    ./cadvisor.nix
  ];
}