{ config, pkgs, ... }:

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
  boot.extraModulePackages = [ config.boot.kernelPackages.framework-laptop-kmod ];
  boot.kernelModules = [
    "cros_ec"
    "cros_ec_lpcs"
    "framework_laptop"
  ];

  services.fwupd.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
  '';

  networking.hostName = "chell";
  system.stateVersion = "26.05";
}
