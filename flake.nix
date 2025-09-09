{
  description = "NixOS configuration";

  # inputs = {
  #   nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  #   home-manager.url = "github:nix-community/home-manager/release-25.05";
  #   home-manager.inputs.nixpkgs.follows = "nixpkgs";
  # };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, stylix, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          stylix.nixosModules.stylix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.users.x = ./home.nix;
          }
        ];
      };
    };
  };
}
