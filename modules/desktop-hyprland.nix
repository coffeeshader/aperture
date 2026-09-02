{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.Hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
    };
  };
}
