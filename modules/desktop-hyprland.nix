{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings.default_session.command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-user-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
  };

  systemd.tmpfiles.rules = [ "d /var/cache/tuigreet 0755 greeter greeter -" ];

  programs.ssh.askPassword = lib.getExe pkgs.kdePackages.ksshaskpass;

  security.pam.services.login.kwallet = {
    enable = true;
    forceRun = true;
  };

  systemd.user.services.plasma-kwallet-pam = {
    description = "Unlock kwallet from pam credentials";
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
      Type = "simple";
      Slice = "background.slice";
      Restart = "no";
    };
  };

  environment.systemPackages = [
    pkgs.kdePackages.kwallet
    pkgs.kdePackages.kwalletmanager
  ];

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.Hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
    };
  };
}
