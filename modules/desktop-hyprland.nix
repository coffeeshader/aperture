{ pkgs, ... }:

{
  imports = [ ./desktop.nix ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
    };
  };
}
