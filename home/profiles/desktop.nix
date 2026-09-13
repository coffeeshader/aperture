{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.playerctl
    pkgs.brightnessctl
    pkgs.hyprpicker
    pkgs.wl-clipboard
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main.icon-theme = "Papirus-Dark";
      border = {
        width = 3;
        radius = 10;
      };
      key-bindings = {
        prev = "Up Control+p Control+k";
        next = "Down Control+n Control+j";
        delete-line-forward = "none";
      };
    };
  };

  programs.hyprlock.enable = true;

  services.hyprpolkitagent.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = config.idle.screenOnCommand;
      };
      listener =
        lib.optional (config.idle.lockAfter != null) {
          timeout = config.idle.lockAfter;
          on-timeout = "loginctl lock-session";
        }
        ++ lib.optional (config.idle.dimAfter != null) {
          timeout = config.idle.dimAfter;
          on-timeout = config.idle.dimCommand;
          on-resume = config.idle.undimCommand;
        }
        ++ lib.optional (config.idle.screenOffAfter != null) {
          timeout = config.idle.screenOffAfter;
          on-timeout = config.idle.screenOffCommand;
          on-resume = config.idle.screenOnCommand;
        };
    };
  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-radius = 10;
      max-visible = 5;
      layer = "overlay";
    };
  };
}
