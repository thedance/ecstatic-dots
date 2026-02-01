{
  description = "Fingerpint scanner flake build from github.com/ahbnr/nixos-06cb-009a-fingerprint-sensor";
  
  inputs = {
    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-06cb-009a-fingerprint-sensor,
    ...
  }
  @attrs:
  let
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./configuration.nix
#          nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
#          nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity
        ];
      };
    };
  };
}