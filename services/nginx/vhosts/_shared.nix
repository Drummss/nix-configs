{ config, ... }:
{
  mkProxyConfig = domain: endpoint: {
    locations."/".proxyPass = endpoint;
    useACMEHost = domain;
    forceSSL = true;
  };
}
