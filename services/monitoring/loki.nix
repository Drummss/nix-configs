{ ... }:
let
  lokiPort = 7510;
in {
  services.loki = {
    enable = true;
    port = lokiPort;
    
  };
  
  networking.firewall.allowedTCPPorts = [ lokiPort ];
}