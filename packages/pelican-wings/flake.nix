{
  description = "Pelican Wings daemon packaged for NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      # Packages are built using the nixpkgs pinned in this flake
      packages.${system}.default = pkgs.callPackage (import "${self}/package.nix") {};

      # Overlays are applied on an existing nixpkgs instance. final and prev both represent that instance.
      # Always use final unless you have a good reason to refer to prev (e.g. avoid infinite recursion).
      overlays.${system} = {
        default = final: prev: { pelican-wings = final.callPackage (import "${self}/package.nix") {}; };
        # You can provide an overlay which uses the package built from your pinned nixpkgs also.
        pinned = final: prev: { pelican-wings = self.outputs.packages.${system}.default; };
      };

      nixosModules = {
        default.imports = [ self.outputs.nixosModules.pelican-wings self.outputs.nixosModules.overlay ];
        overlay.nixpkgs.overlays = [ self.overlays.${system}.default ];
        pelican-wings = import ./module.nix;
      };
    };
}
