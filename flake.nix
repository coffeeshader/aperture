{
  outputs =
    { self, ... }:
    let
      inputs = (import ./.tack) { } // {
        inherit self;
      };
      inherit (inputs) nixpkgs home-manager;
      user = "coffeeshader";
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      environments = import ./packages/environments.nix { inherit pkgs; };
      mkHost =
        name:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs user; };
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
      nixosConfigurations.chell = mkHost "chell";
    };
}
