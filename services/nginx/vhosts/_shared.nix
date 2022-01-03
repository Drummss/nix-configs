{ config, ... }:
{
  mkProxyConfig = domain: endpoint: {
    locations."/" = {
      proxyPass = endpoint;
      proxyWebsockets = true;
    };
    useACMEHost = domain;
    forceSSL = true;
  };
}
