{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/audio.nix
    ../../modules/vpn.nix
    ../../modules/syncthing.nix
    ../../modules/claude-code.nix
    ../../modules/codex.nix
    ../../modules/desktop-hyprland.nix
    ../../modules/gaming.nix
    ../../modules/vr.nix
    ../../modules/yubikey.nix
    ../../modules/power.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.fwupd.enable = true;

  networking.hostName = "chell";
  system.stateVersion = "26.05";
}
