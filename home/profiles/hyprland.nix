{ config, pkgs, ... }:

let
  color = name: config.theme.paletteOled.${name};
  cursor = config.home.pointerCursor;
in
{
  imports = [ ./desktop.nix ];

  home.packages = [
    (pkgs.writers.writeNuBin "sync-monitor-scale" (
      builtins.readFile ../dotfiles/hyprland/sync-monitor-scale.nu
    ))
  ];

  systemd.user.services.awww.Service.ExecStartPost =
    "${config.services.awww.package}/bin/awww img ${config.home.homeDirectory}/Documents/Wallpapers/orange-clouds.jpg";

  services.hyprsunset = {
    enable = true;
    extraArgs = [ "-i" ];
  };

  idle = {
    dimCommand = "hyprctl hyprsunset gamma 30";
    undimCommand = "hyprctl hyprsunset gamma 100";
    screenOffCommand = ''hyprctl eval "hl.dispatch(hl.dsp.dpms({ action = 'off' }))"'';
    screenOnCommand = ''hyprctl eval "hl.dispatch(hl.dsp.dpms({ action = 'on' }))"'';
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
    . ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh
    export XCURSOR_THEME=${cursor.name}
    export XCURSOR_SIZE=${toString cursor.size}
    export HYPRCURSOR_THEME=${cursor.name}
    export HYPRCURSOR_SIZE=${toString cursor.size}
    export QT_STYLE_OVERRIDE=kvantum
  '';
}
