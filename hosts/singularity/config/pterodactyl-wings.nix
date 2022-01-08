{ config, ... }:
{
  pterodactyl-wings = {
    enable = true;
    panelUrl = "https://pterodactyl.unkn.in";
    nodeId = 1;
    apiPort = 7005;
    sftpPort = 7006;
    token = "uNowv6c7zJw0JfydSvU2KuWLd5XjVEbsNFR91zNmGGDhQ9GO";
    extraConfig.api.ssl = {
      cert = config.security.acme.certs."${config.unknin.domain}".directory + "/cert.pem";
      key = config.security.acme.certs."${config.unknin.domain}".directory + "/key.pem";
    };
  };
}