{ lib, pkgs, ... }:

{
  imports = [
    ./common
    ./profiles/plasma.nix
    ./profiles/ai.nix
    ./profiles/gaming.nix
    ./profiles/modding.nix
    ./profiles/library.nix
    ./profiles/university.nix
  ];

  programs.plasma.startup.startupScript.monitor.text = ''
    ${lib.getExe' pkgs.kdePackages.libkscreen "kscreen-doctor"} \
      output.eDP-2.scale.1.5 \
      output.eDP-2.vrrpolicy.always
  '';

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
