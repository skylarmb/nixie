{
  description = "Skylar's dotfiles and home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TPM - Tmux Plugin Manager
    tpm = {
      url = "github:tmux-plugins/tpm";
      flake = false;
    };

    # Stylix - system-wide theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, tpm, stylix }:
    let
      lib = nixpkgs.lib;

      # Per-machine specs. Add a new machine by creating machines/<name>.nix
      # and adding an entry here. The selector for `home-manager switch
      # --flake .#<user>@<name>` is the attribute key below.
      machines = {
        workstation = { file = ./machines/workstation.nix; system = "x86_64-linux";   isDarwin = false; };
        rog    = { file = ./machines/rog.nix;    system = "x86_64-linux";   isDarwin = false; };
        hh     = { file = ./machines/hh.nix;     system = "aarch64-darwin"; isDarwin = true;  };
      };

      # Build a homeManagerConfiguration for one machine spec.
      mkHome = m:
        let userConfig = import m.file;
        in home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${m.system};
          extraSpecialArgs = {
            inherit userConfig tpm;
            isDarwin = m.isDarwin;
          };
          modules = [ ./home.nix ];
        };
    in
    {
      # One homeConfiguration per machine: <user>@<machine>.
      homeConfigurations = lib.mapAttrs' (
        name: m: lib.nameValuePair "${(import m.file).username}@${name}" (mkHome m)
      ) machines;

      # NixOS system configuration (rog box).
      nixosConfigurations.nixos =
        let userConfig = import ./machines/rog.nix;
        in nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit userConfig tpm; };
          modules = [
            ./configuration.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit userConfig tpm; isDarwin = false; };
            }
          ];
        };
    };
}
