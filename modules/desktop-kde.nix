{ lib, pkgs, ... }:

{
  services = {
    displayManager.plasma-login-manager.enable = true;
    desktopManager.plasma6.enable = true;
  };

  environment.plasma6.excludePackages = [
    pkgs.kdePackages.elisa
    pkgs.kdePackages.okular
    pkgs.kdePackages.khelpcenter
    pkgs.kdePackages.plasma-browser-integration
    pkgs.kdePackages.krdp
    pkgs.kdePackages.kate
    pkgs.kdePackages.ktexteditor
    pkgs.kdePackages.spectacle
    pkgs.kdePackages.gwenview
    pkgs.kdePackages.konsole
    pkgs.kdePackages.plasma-keyboard
    pkgs.kdePackages.qtvirtualkeyboard
    pkgs.kdePackages.union
    pkgs.kdePackages.aurorae
    pkgs.kdePackages.qrca
    pkgs.kdePackages.baloo-widgets
  ];

  programs.kde-pim.merkuro = false;

  security.pam.services = {
    login.kwallet.enable = lib.mkForce false;
    kde.kwallet.enable = lib.mkForce false;
  };

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };
}
