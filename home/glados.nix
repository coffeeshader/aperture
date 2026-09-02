{ ... }:

{
  imports = [
    ./common
    ./profiles/hyprland.nix
    ./profiles/gaming.nix
    ./profiles/modding.nix
    ./profiles/library.nix
  ];

  theme.oled = true;

  home.stateVersion = "26.05";
}
