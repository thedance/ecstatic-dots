{
  description = "NixOS flake with Zen Browser";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, zen-browser, ... }:
    let
      system = "x86_64-linux";
      hostname = "nixos"; # adjust to your hostname
    in
    {
      nixosConfigurations = {
        "${hostname}" = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix # your existing config

            # Zen Browser package
            {
              environment.systemPackages = [
                zen-browser.packages.${system}.default
              ];
            }
          ];
        };
      };
    };
}
