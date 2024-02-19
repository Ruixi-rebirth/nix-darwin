{
  description = "Example Darwin system flake";


  outputs = inputs @ { self, nixpkgs, flake-parts, nix-darwin, ... }:
    let
      user = "luxin";
      domain = "ruixi2fp.top";
      selfPkgs = import ./pkgs;
    in


    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-darwin" ];
      imports = [
        inputs.flake-root.flakeModule
        inputs.mission-control.flakeModule
        inputs.treefmt-nix.flakeModule
      ];
      perSystem = { config, inputs', pkgs, system, lib, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
            ];
          };
        in
        {
          treefmt.config = {
            inherit (config.flake-root) projectRootFile;
            package = pkgs.treefmt;
            programs.nixpkgs-fmt.enable = true;
            programs.prettier.enable = true;
            programs.taplo.enable = true;
            programs.stylua.enable = true;
            programs.beautysh = {
              enable = true;
              indent_size = 4;
            };
          };
          mission-control.scripts = {
            update = {
              description = "Update flake inputs";
              exec = "nix flake update";
              category = "Tools";
            };
            rebuild = {
              description = "Switch to new profile";
              exec = "darwin-rebuild switch --flake .#macbook";
              category = "Tools";
            };
            fmt = {
              description = "Format the source tree";
              exec = config.treefmt.build.wrapper;
              category = "Tools";
            };
          };

          devShells = {
            #run by `nix devlop` or `nix-shell`(legacy)
            #Temporarily enable experimental features, run by`nix develop --extra-experimental-features nix-command --extra-experimental-features flakes`
            default = pkgs.mkShell {
              nativeBuildInputs = with pkgs; [
                git
                neovim
              ];
              shellHook = ''
                export PS1="\[\e[0;31m\](Secret)\$ \[\e[m\]"
              '';
              inputsFrom = [
                config.flake-root.devShell
                config.mission-control.devShell
              ];
            };
          };
        };
      flake = {
        overlays.default = selfPkgs.overlay;
        darwinConfigurations = (
          import ./darwin.nix {
            system = "x86_64-darwin";
            inherit nixpkgs nix-darwin self inputs user;
          }
        );
        # Expose the package set, including overlays, for convenience.
        darwinPackages = self.darwinConfigurations."MacBook".pkgs;
      };

    };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    joshuto.url = "github:Ruixi-rebirth/joshuto/dev";
    nixd.url = "github:nix-community/nixd";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    flake-root.url = "github:srid/flake-root";
    mission-control.url = "github:Platonic-Systems/mission-control";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nvim-flake.url = "github:Ruixi-rebirth/nvim-flake";
  };
}
