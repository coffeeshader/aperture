{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/audio.nix
    ../../modules/syncthing.nix
    ../../modules/desktop-hyprland.nix
    ../../modules/gaming.nix
    ../../modules/vr.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "glados";
  system.stateVersion = "26.05";
}
