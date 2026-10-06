{ ... }:

{
  imports = [
    ./common
    ./profiles/niri.nix
    ./profiles/ai.nix
    ./profiles/gaming.nix
    ./profiles/modding.nix
    ./profiles/library.nix
    ./profiles/university.nix
  ];

  theme.oled = false;
  theme.font = {
    family = "CommitMonoAperture";
    size = 14;
  };

  idle = {
    dimAfter = 60;
    screenOffAfter = 120;
    lockAfter = 180;
    suspendAfter = 300;
    suspendOnBatteryOnly = true;
  };

  home.stateVersion = "26.05";
}
