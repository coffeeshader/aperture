{ pkgs, ... }:

{
  imports = [ ./desktop.nix ];

  programs.niri.enable = true;

  services.gnome.gnome-keyring.enable = false;

  environment.systemPackages = [ pkgs.xwayland-satellite ];
}
