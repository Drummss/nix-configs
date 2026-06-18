{ pkgs, ... }:

let
  user = "drumsy";
  home = "/home/${user}";

  vscodeSettings = {
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
    "nix.formatterPath" = "${pkgs.nixfmt}/bin/nixfmt";

    "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";

    "terminal.integrated.env.linux"."EDITOR" = "openvscode-server --wait";
    "terminal.integrated.localEchoEnabled" = "off";

    "nix.serverSettings" = {
      "nixd" = {
        "formatting" = {
          "command" = [ "${pkgs.nixfmt}/bin/nixfmt" ];
        };
      };
    };
  };

  vscodeSettingsFile = pkgs.writeText "openvscode-settings.json" (builtins.toJSON vscodeSettings);
in
{
  environment.systemPackages = with pkgs; [
    openvscode-server
    nixfmt
    git

    # Required by extensions
    nixd
    direnv
    nix-direnv
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  systemd.services.openvscode-copy-settings-drummss = {
    serviceConfig.Type = "oneshot";
    description = "OpenVSCode - Copy Settings for Drummss";
    before = [ "openvscode-server-drummss.service" ];
    requiredBy = [ "openvscode-server-drummss.service" ];
    script = ''
      install -d -m 0755 -o ${user} -g users ${home}/.openvscode-server/data/Machine
      install -m 0644 -o ${user} -g users ${vscodeSettingsFile} ${home}/.openvscode-server/data/Machine/settings.json

      echo "OpenVSCode settings written:"
      cat ${home}/.openvscode-server/data/Machine/settings.json
    '';
  };

  systemd.services.openvscode-server-drummss = {
    description = "OpenVSCode Server for Drummss";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    path = with pkgs; [
      nixd
      direnv
      nix-direnv
      nixfmt
      git
    ];

    serviceConfig = {
      User = "drummss";
      WorkingDirectory = "/home/drummss";
      Restart = "always";

      ExecStart = ''
        ${pkgs.openvscode-server}/bin/openvscode-server \
          --host 127.0.0.1 \
          --port 3000 \
          --telemetry-level=off \
          --accept-server-license-terms \
          --without-connection-token
      '';
    };
  };
}
