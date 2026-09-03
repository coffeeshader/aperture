{ inputs, pkgs, ... }:

{
  home.packages = [ inputs.grimoire.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
