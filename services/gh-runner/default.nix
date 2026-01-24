{ pkgs, ... }: {
  services.github-runner = {
    # enable = true;
    name = "gh-singularity-1";
    extraLabels = [ "singularity" ];
    url = "https://github.com/Drummss/PandaBot";
    tokenFile = "/var/secrets/gh-runner/token";
  };

  systemd.services.github-runner.serviceConfig = {
    SupplementaryGroups = [ "docker" ];                                                                                                                                                                                                         
    ProtectControlGroups = pkgs.lib.mkForce false;                                                                                                                                                                                              
    RestrictNamespaces = pkgs.lib.mkForce false;        
    # ProtectHome = pkgs.lib.mkForce false;
    # ProtectHostname = pkgs.lib.mkForce false;                                                                                                                                                                                    
  };
}