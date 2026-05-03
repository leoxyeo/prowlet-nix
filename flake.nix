{
  description = "Nix flake for prowlet - Query the Prowlarr search API from the CLI";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSystem = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forEachSystem (pkgs:
        let prowlet = pkgs.callPackage ./package.nix { };
        in {
          inherit prowlet;
          default = prowlet;
        });

      overlays.default = final: _prev: {
        prowlet = final.callPackage ./package.nix { };
      };

      nixosModules.default = { pkgs, ... }: {
        nixpkgs.overlays = [ self.overlays.default ];
        environment.systemPackages = [ pkgs.prowlet ];
      };
    };
}
