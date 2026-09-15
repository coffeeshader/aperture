{ config, ... }:

{
  imports = [ ./desktop.nix ];

  idle = {
    dimCommand = "brightnessctl -s set 30%";
    undimCommand = "brightnessctl -r";
    screenOffCommand = "niri msg action power-off-monitors";
    screenOnCommand = "niri msg action power-on-monitors";
  };

  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.repo.root}/home/dotfiles/niri/config.kdl";

  systemd.user.sessionVariables = config.home.sessionVariables // {
    QT_STYLE_OVERRIDE = "kvantum";
  };
}
