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
  };

  outputs = { self, nixpkgs, home-manager, tpm }:
    let
      # User configuration - customize these for your setup
      userConfig = {
        username = "skylar";
        email = "skylar@honeyhive.ai";
        fullName = "Skylar Brown";
        gpgKey = "E51A3E86541F5FCF";  # Optional, set to null if not using GPG signing
        timezone = "America/Los_Angeles";
      };

      # Helper function to create home-manager configuration
      mkHomeConfiguration = system: {
        inherit system;
        modules = [
          ./home.nix
          {
            # Pass user config to home.nix
            _module.args = {
              inherit userConfig tpm;
            };
          }
        ];
      };
    in
    {
      # macOS (darwin) configuration
      homeConfigurations."${userConfig.username}@darwin" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          ./home.nix
          {
            _module.args = {
              inherit userConfig tpm;
              isDarwin = true;
            };
          }
        ];
      };

      # Linux configuration
      homeConfigurations."${userConfig.username}@linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
          {
            _module.args = {
              inherit userConfig tpm;
              isDarwin = false;
            };
          }
        ];
      };

      # NixOS system configuration
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit userConfig tpm; };
        modules = [
          ./configuration.nix
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
