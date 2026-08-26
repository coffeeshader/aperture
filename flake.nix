{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      user = "coffeeshader";
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      environments = import ./packages/environments.nix { inherit pkgs; };
      mkHost =
        name:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/${name}
            ./modules/common.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.${user} = import ./home/${name}.nix;
              };
            }
          ];
        };
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;
      packages.${system} = environments;
      devShells.${system} = builtins.mapAttrs (
        _: environment:
        pkgs.mkShellNoCC {
          packages = [ environment ];
        }
      ) environments;
      nixosConfigurations.glados = mkHost "glados";
    };
}
