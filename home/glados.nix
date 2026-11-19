{ pkgs, ... }:

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
