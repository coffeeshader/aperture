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

  idle = {
    dimAfter = 60;
    screenOffAfter = 120;
  };

  home.stateVersion = "26.05";
}
