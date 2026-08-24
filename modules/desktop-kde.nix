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

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    okular
    khelpcenter
    print-manager
    plasma-browser-integration
    krdp
    konsole
  ];

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };
}
