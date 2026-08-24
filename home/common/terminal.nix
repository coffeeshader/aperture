{ pkgs, ... }:

{
  home.packages = [ pkgs.foot ];

  xdg.configFile."foot/foot.ini".source = ../dotfiles/foot/foot.ini;
}
