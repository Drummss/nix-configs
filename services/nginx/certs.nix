{ config, ... }:
let
  domain = config.unknin.domain;
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "drumsyy@outlook.com";
    # Staging server for testing
    # server = "https://acme-staging-v02.api.letsencrypt.org/directory";

    certs."${domain}" = {
      domain = "*.${domain}";
      dnsProvider = "cloudflare";
      environmentFile = "/var/secrets/cloudflare/unkn-in/env";
      credentialFiles = {
        "CF_API_KEY_FILE" = "/var/secrets/cloudflare/unkn-in/key.secret";
      };
    };

    certs."singularity.${domain}" = {
      domain = "*.singularity.${domain}";
      dnsProvider = "cloudflare";
      environmentFile = "/var/secrets/cloudflare/unkn-in/env";
      credentialFiles = {
        "CF_API_KEY_FILE" = "/var/secrets/cloudflare/unkn-in/key.secret";
      };
    };


    #certs."pandabot.one" = {
    #  domain = "*.pandabot.one";
    #  dnsProvider = "cloudflare";
    #  credentialsFiles = "/var/secrets/cloudflare.pandabot.one.secret";
    #};
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
