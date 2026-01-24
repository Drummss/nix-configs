{ config, ... }:
let
  grafanaPort = 7500;
in {
  services.cadvisor = {
    enable = true;
    port = 7503;
  };
}