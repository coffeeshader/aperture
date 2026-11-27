{ lib, pkgs, ... }:

let
  apply-display-settings = pkgs.writers.writeNuBin "apply-display-settings" {
    makeWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath [ pkgs.kdePackages.libkscreen ])
    ];
  } (builtins.readFile ./dotfiles/apply-display-settings.nu);
in
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

  home.packages = [
    pkgs.razergenie
    apply-display-settings
  ];

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

  programs.plasma.startup.startupScript.monitor.text = lib.getExe apply-display-settings;

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
