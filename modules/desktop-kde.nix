{ pkgs, ... }:

{
  services = {
    xserver.enable = false;

    displayManager = {
      plasma-login-manager.enable = true;
      defaultSession = "plasma";
    };

    desktopManager.plasma6.enable = true;
  };

  environment.plasma6.excludePackages = [
    pkgs.kdePackages.elisa
    pkgs.kdePackages.okular
    pkgs.kdePackages.khelpcenter
    pkgs.kdePackages.print-manager
    pkgs.kdePackages.plasma-browser-integration
    pkgs.kdePackages.krdp
    pkgs.kdePackages.kate
    pkgs.kdePackages.ktexteditor
    pkgs.kdePackages.spectacle
    pkgs.kdePackages.gwenview
    pkgs.kdePackages.konsole
  ];

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };
}
