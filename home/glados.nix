{ lib, pkgs, ... }:

{
  imports = [
    ./common
    ./profiles/plasma.nix
    ./profiles/ai.nix
    ./profiles/gaming.nix
    ./profiles/modding.nix
    ./profiles/library.nix
    ./profiles/torrent.nix
    ./profiles/university.nix
  ];

  home.packages = [ pkgs.razergenie ];

  programs.plasma.input.mice = [
    {
      name = "Razer Razer Viper V3 Pro";
      vendorId = "1532";
      productId = "00c1";
      acceleration = -0.6;
      accelerationProfile = "none";
    }
  ];

  programs.plasma.configFile.kwinrc.Windows_HDR = {
    MaxLuminance = 560;
    Reference = 250;
  };

  programs.plasma.startup.startupScript.monitor.text = ''
    ${lib.getExe' pkgs.kdePackages.libkscreen "kscreen-doctor"} \
      output.DP-1.scale.1.3 \
      output.DP-1.vrrpolicy.automatic \
      output.DP-1.hdr.enable \
      output.DP-1.wcg.enable \
      output.DP-1.sdr-brightness.250 \
      output.DP-1.sdrGamut.50 \
      output.DP-1.maxBrightnessOverride.560 \
      output.DP-1.colorPowerTradeoff.preferAccuracy
  '';

  theme.oled = true;
  theme.font = {
    family = "CommitMonoAperture";
    size = 14;
  };

  idle = {
    dimAfter = 90;
    screenOffAfter = 150;
    lockAfter = 600;
  };

  home.stateVersion = "26.05";
}
