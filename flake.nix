{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    sufy-nix.url = "github:Gerg-L/spicetify-nix";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, spicetify-nix, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs; };


      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager
        spicetify-nix.nixosModules.spicetify
      ];
    };
  };
}