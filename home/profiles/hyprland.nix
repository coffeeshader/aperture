{
  config,
  lib,
  pkgs,
  ...
}:

let
  palette =
    (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
    .${config.catppuccin.flavor}.colors;
  color =
    name:
    if config.theme.oled && config.theme.oledColors ? ${name} then
      config.theme.oledColors.${name}.to
    else
      lib.removePrefix "#" palette.${name}.hex;
  cursor = config.home.pointerCursor;
in
{
  home.packages = [
    (pkgs.writers.writeNuBin "sync-monitor-scale" (
      builtins.readFile ../dotfiles/hyprland/sync-monitor-scale.nu
    ))
    
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
    };
  };

  services.hyprpaper =
    let
      # Change this later to a wallpaper in dotfiles/
      wallpaper = "${config.home.homeDirectory}/Documents/Wallpapers/orange-clouds.jpg";
    in
    {
      enable = true;
      settings = {
        splash = false;
        wallpaper = {
          monitor = "*";
          path = wallpaper;
        };
      };
    };

  services.hyprpolkitagent.enable = true;

  services.hyprsunset = {
    enable = true;
    extraArgs = [ "-i" ];
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = ''hyprctl eval "hl.dispatch(hl.dsp.dpms({ action = 'on' }))"'';
      };
      listener =
        lib.optional (config.idle.dimAfter != null) {
          timeout = config.idle.dimAfter;
          on-timeout = "hyprctl hyprsunset gamma 30";
          on-resume = "hyprctl hyprsunset gamma 100";
        }
        ++ lib.optional (config.idle.screenOffAfter != null) {
          timeout = config.idle.screenOffAfter;
          on-timeout = ''hyprctl eval "hl.dispatch(hl.dsp.dpms({ action = 'off' }))"'';
          on-resume = ''hyprctl eval "hl.dispatch(hl.dsp.dpms({ action = 'on' }))"'';
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

  xdg.configFile."hypr/hyprland.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.repo.root}/home/dotfiles/hyprland/hyprland.lua";

  xdg.configFile."hypr/theme.lua".text = ''
    theme = {
      accent   = "${color config.catppuccin.accent}",
      lavender = "${color "lavender"}",
      surface1 = "${color "surface1"}",
      crust    = "${color "crust"}",
    }
  '';

  xdg.configFile."uwsm/env".text = ''
    export XCURSOR_THEME=${cursor.name}
    export XCURSOR_SIZE=${toString cursor.size}
    export HYPRCURSOR_THEME=${cursor.name}
    export HYPRCURSOR_SIZE=${toString cursor.size}
    export QT_STYLE_OVERRIDE=kvantum
  '';
}
