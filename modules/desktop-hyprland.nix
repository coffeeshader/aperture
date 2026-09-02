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
    settings.default_session.command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-user-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
  };

  systemd.tmpfiles.rules = [ "d /var/cache/tuigreet 0755 greeter greeter -" ];

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
