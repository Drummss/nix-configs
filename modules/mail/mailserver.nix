{ config, pkgs, lib, ... }:
{
  mailserver = {
    enable = true;

    # Mail server hostname.
    fqdn = "smtp.unkn.in";
    
    # Domains to receive emails for.
    domains = [
      "unkn.in"
    ];

    # Use existing ACME certs instead of letting the mailserver module
    # create its own nginx/ACME setup.
    certificateScheme = "acme";

    # Main mailbox.
    loginAccounts = {
      "drummss@unkn.in" = {
        hashedPasswordFile = "/var/lib/mailserver/secrets/drummss.hash";

        aliases = [
          "postmaster@unkn.in"
          "abuse@unkn.in"
          "admin@unkn.in"
          "contact@unkn.in"
        ];

        quota = "10G";
      };
    };

    # Optional. I would leave this disabled at first because catch-alls
    # tend to attract spam.
    #
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
