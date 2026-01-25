{ pkgs, config, lib, ... }: {
  # Special settings to make Nix Flakes experience more homogenous
  nix = {
    channel.enable = false;
    settings = {
      # Clear the flake registry URL - we don't want a public list of
      # flake names pulled on every command invokation.
      flake-registry = "";
      # Flakes are experimental... for the last eternity
      experimental-features = [ "nix-command" "flakes" ];
      # Enable cachix for a broader community-scoped binary cache
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Also set the NIX_PATH appropriately so legacy commands use our nixpkgs and not the
    # channels. You may have to rm ~/.nix-defexpr/channels too.
    # Kind thanks to tejingdesk for this idea:
    # https://github.com/tejing1/nixos-config/blob/222692910d9c8c44ff066f86f4a2dd1e46f629d3/nixosConfigurations/tejingdesk/registry.nix#L12
    nixPath = [ "/etc/nix/path" ];
  };
  environment.etc."nix/path/nixpkgs".source = pkgs.path;

  nixpkgs.config.allowUnfree = true;
}
