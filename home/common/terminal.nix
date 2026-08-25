{ config, lib, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "IntelOneMono:size=11";
        login-shell = "yes";
        resize-by-cells = "no";
      };

      colors = lib.mkIf (!config.theme.oled) { alpha = "0.85"; };
    };
  };
}
