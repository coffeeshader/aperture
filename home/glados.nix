{ ... }:

{
  imports = [
    ./common
    ./plasma.nix
    ./gaming.nix
  ];

  theme.oled = true;

  home.stateVersion = "26.05";
}
