{
  lib,
  pkgs,
  ...
}:

{
  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings.default_session.command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-user-session --sessions /run/current-system/sw/share/wayland-sessions";
  };

  systemd.tmpfiles.rules = [ "d /var/cache/tuigreet 0755 greeter greeter -" ];

  programs.ssh.askPassword = lib.getExe pkgs.kdePackages.ksshaskpass;
}
