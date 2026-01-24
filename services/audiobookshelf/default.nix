{ config, pkgs, ... }:
let
  rootDom = config.unknin.domain;
  domain = "kiku.${rootDom}";
in {
  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0";
    port = 7060;
  };
}
