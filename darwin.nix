{ system, self, nixpkgs, inputs, user, nix-darwin, ... }:

let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; 
    config.allowUnsupportedSystem = true;
  };

  lib = nix-darwin.lib;
in
{
  macbook = lib.darwinSystem {
    inherit system;
    specialArgs = { inherit inputs user; };
    modules = [
      ./system.nix
    ] ++ [
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit user inputs; };
          users.${user} = {
            imports = [
              (import ./home.nix)
            ] ++ [
            ];
          };
        };
        nixpkgs = {
          overlays =
            [
              self.overlays.default
              inputs.nixd.overlays.default
            ];
        };
      }
    ];
  };
}
