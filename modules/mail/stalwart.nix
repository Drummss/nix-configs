{ config, ... }:

let
  domain = "stalwart.unkn.in";
in
{
  virtualisation.oci-containers.containers.stalwart = {
    image = "docker.io/stalwartlabs/stalwart:v0.16";
    autoStart = true;

    ports = [
      # Mail Ports
      "25:25"
      "465:465"
      "993:993"

      # Admin Panel
      "127.0.0.1:8088:8080"
    ];

    volumes = [
      "/etc/stalwart:/etc/stalwart"
      "/var/lib/stalwart:/var/lib/stalwart"
      "/var/lib/acme/unkn.in:/var/lib/acme/unkn.in:ro"
      "/home/drummss/mail-migration-backup:/migration:ro"
    ];

    environment = {
      STALWART_PUBLIC_URL = "https://${domain}";
    };

    extraOptions = [
      "--add-host=host.docker.internal:host-gateway"
      "--group-add=994"
    ];
  };

  systemd.tmpfiles.rules = [
    # Docker image expects UID 2000 on bind-mounted dirs.
    "d /etc/stalwart 0750 2000 2000 -"
    "d /var/lib/stalwart 0750 2000 2000 -"
    "d /var/log/stalwart 0750 2000 2000 -"
  ];

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    useACMEHost = config.unknin.domain;

    locations."/" = {
      proxyPass = "http://127.0.0.1:8088";
      proxyWebsockets = true;

      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port 443;
      '';
    };
  };

  networking.hosts."127.0.0.1" = [
    "smtp.unkn.in"
  ];

  networking.firewall.allowedTCPPorts = [
    25   # SMTP server-to-server delivery
    465  # SMTP submission over TLS
    993  # IMAPS
  ];
}