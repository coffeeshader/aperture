{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop-kde.nix
    ../../modules/gaming.nix
    ../../modules/vr.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "glados"; # Define your hostname.
  system.stateVersion = "26.05"; # Did you read the comment?
}
