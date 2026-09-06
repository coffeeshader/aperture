{ ... }:

{
  imports = [
    ./common
    ./profiles/hyprland.nix
    ./profiles/ai.nix
    ./profiles/gaming.nix
    ./profiles/modding.nix
    ./profiles/library.nix
  ];

  theme.oled = true;

  idle = {
    dimAfter = 90;
    screenOffAfter = 150;
    lockAfter = 600;
  };

  home.stateVersion = "26.05";
}
