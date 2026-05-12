{ config, pkgs, lib, ... }:
{
  mailserver = {
    enable = true;
    stateVersion = 3;

    # Mail server hostname.
    fqdn = "smtp.unkn.in";
    
    # Domains to receive emails for.
    domains = [
      "unkn.in"
    ];

    x509.useACMEHost = config.unknin.domain;
    
    # Mail boxes.
    #
    # To add a new account, you will need to generate a password with:
    # > nix shell nixpkgs#mkpasswd -c mkpasswd -sm bcrypt
    # And then put paste the password into a file like:
    # > sudo nano /var/lib/mailserver/secrets/<account_name>.hash
    accounts = {
      "admin@unkn.in" = {
        hashedPasswordFile = "/var/lib/mailserver/secrets/admin.hash";

        aliases = [
          "postmaster@unkn.in"
          "abuse@unkn.in"
          "admin@unkn.in"
          "contact@unkn.in"
        ];

        quota = "10G";
      };

      "drummss@unkn.in" = {
        hashedPasswordFile = "/var/lib/mailserver/secrets/drummss.hash";
        quota = "10G";
      };

      "darkstar@unkn.in" = {
        hashedPasswordFile = "/var/lib/mailserver/secrets/darkstar.hash";
        quota = "10G";
      };
    };

    # This would act as a catch-all - and send all mail to the supplied mail box. 
    # forwards = {
    #   "@unkn.in" = "drummss@unkn.in";
    # };

    enableImap = true;
    enableImapSsl = true;

    enableSubmission = true;
    enableSubmissionSsl = true;

    enablePop3 = false;
    enablePop3Ssl = false;
  };

  networking.firewall.allowedTCPPorts = [
    25   # SMTP server-to-server delivery
    465  # SMTP submission over TLS
    587  # SMTP submission with STARTTLS
    993  # IMAPS
  ];
}
