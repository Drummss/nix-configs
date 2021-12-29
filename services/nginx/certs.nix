{ config, ... }:
let
  domain = config.unknin.domain;
in {
  security.acme = {
    acceptTerms = true;
    email = "drumsyy@outlook.com";
    # Staging server for testing
    # server = "https://acme-staging-v02.api.letsencrypt.org/directory";

    certs."${domain}" = {
      domain = "*.${domain}";
      dnsProvider = "cloudflare";
      credentialsFile = "/var/secrets/cloudflare.${domain}.secret";
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
