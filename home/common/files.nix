{ pkgs, ... }:

{
  programs.yazi.enable = true;

  home.packages = [
    pkgs.kdePackages.ark
  ];
}
