{
  inputs,
  lib,
  pkgs,
  user,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/audio.nix
    ../../modules/vpn.nix
    ../../modules/syncthing.nix
    ../../modules/claude-code.nix
    ../../modules/codex.nix
    ../../modules/desktop-kde.nix
    ../../modules/gaming.nix
    ../../modules/vr.nix
    ../../modules/yubikey.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages =
    inputs.nix-cachyos-kernel.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linuxPackages-cachyos-latest;

  specialisation.linux-latest.configuration = {
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  };

  powerManagement.cpuFreqGovernor = "performance";

  hardware.openrazer = {
    enable = true;
    users = [ user ];
  };

  networking.hostName = "glados";
  system.stateVersion = "26.05";
}
