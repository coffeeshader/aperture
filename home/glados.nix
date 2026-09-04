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
    dimAfter = 60;
    screenOffAfter = 120;
    lockAfter = 300;
  };

  home.stateVersion = "26.05";
}
