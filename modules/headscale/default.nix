{ config, pkgs, ... }:

{
  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 7770;

    settings = {
      server_url = "https://headscale.unkn.in";

      listen_addr = "127.0.0.1:7770";
      metrics_listen_addr = "127.0.0.1:7771";

      trusted_proxies = [
        "127.0.0.1/32"
        "::1/128"
      ];

      dns = {
        magic_dns = true;
        base_domain = "net.unkn.in";

        nameservers = {
          global = [
            "1.1.1.1"
            "1.0.0.1"
          ];
        };
      };

      oidc = {
        issuer = "https://auth.unkn.in/application/o/headscale/";
        client_id = "headscale";
        client_secret_path = "/var/secrets/headscale/client-secret";

        scope = [
          "openid"
          "profile"
          "email"
          "groups"
        ];

        pkce = {
          enabled = true;
        };

        # allowed_groups = [
        #   "headscale-users"
        #   "headscale-admins"
        # ];
      };

      policy = {
        mode = "file";
        path = "/etc/headscale/acl.hujson";
      };
    };
  };

  environment.etc."headscale/acl.hujson".text = ''
    {
      "groups": {
        "group:admins": [
          "administrator@",
          "drummss@",
          "darkstar@",
        ],
      },

      "tagOwners": {
        "tag:server": ["group:admins"],
        "tag:vscode": ["group:admins"],
        "tag:admin": ["group:admins"],
      },

      "acls": [
        // Admins can access everything.
        {
          "action": "accept",
          "src": ["group:admins"],
          "dst": ["*:*"],
        },
      ],
    }
  '';

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  services.nginx.virtualHosts."headscale.unkn.in" = {
    forceSSL = true;
    useACMEHost = config.unknin.domain;

    locations."/" = {
      proxyPass = "http://127.0.0.1:7770";
      proxyWebsockets = true;
    };

    locations."/generate_204" = {
      return = "204";
    };
  };

  networking.firewall = {
    trustedInterfaces = [
      config.services.tailscale.interfaceName
    ];

    allowedUDPPorts = [
      config.services.tailscale.port
    ];
  };

  environment.systemPackages = [
    pkgs.headscale
    pkgs.tailscale
  ];
}
