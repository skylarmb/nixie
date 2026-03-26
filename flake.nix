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
      # Machine-specific configuration
      # To add a new machine: create machines/<name>.nix and update the line below
      userConfig = import ./machines/mini.nix;

    in
    {
      # macOS (darwin) configuration
      homeConfigurations."${userConfig.username}@darwin" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {
          inherit userConfig tpm;
          isDarwin = true;
        };
        modules = [ ./home.nix ];
      };

      # Linux configuration
      homeConfigurations."${userConfig.username}@linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit userConfig tpm;
          isDarwin = false;
        };
        modules = [ ./home.nix ];
      };

      # NixOS system configuration
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
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
