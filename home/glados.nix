{ ... }:

{
  imports = [
    ./common
    ./profiles/plasma.nix
    ./profiles/gaming.nix
    ./profiles/modding.nix
  ];

  theme.oled = true;

  # 5120x2160 at scale 1.3
  screen = {
    width = 3939;
    height = 1662;
  };

  home.stateVersion = "26.05";
}
