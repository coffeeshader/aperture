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
    pkgs.playerctl
    pkgs.brightnessctl
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

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-radius = 10;
      max-visible = 5;
      layer = "overlay";
    };
  };

  xdg.configFile."hypr/hyprland.lua".source = ../dotfiles/hyprland/hyprland.lua;

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
  '';
}
