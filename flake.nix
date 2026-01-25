# This can be built with nixos-rebuild --flake .#myhost build
{
  description = "Drummss Big Bad Nix Configs";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  # Outputs can be anything, but the wiki + some commands define their own
  # specific keys. Wiki page: https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs }: {
    # nixosConfigurations is the key that nixos-rebuild looks for.
    nixosConfigurations = {
      singularity = nixpkgs.lib.nixosSystem {
        # A lot of times online you will see the use of flake-utils + a
        # function which iterates over many possible systems. My system
        # is x86_64-linux, so I'm only going to define that
        system = "x86_64-linux";
        # Import our old system configuration.nix
        modules = [
          ./hosts/singularity/configuration.nix
          {
            # Pin the nixpkgs flake to match this flake's revision
            # Source: https://www.tweag.io/blog/2020-07-31-nixos-flakes/ "Pinning Nixpkgs"
            nix.registry.nixpkgs.flake = nixpkgs;
          }
        ];
      };
    };
  };
}
