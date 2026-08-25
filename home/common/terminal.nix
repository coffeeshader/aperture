{ config, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "IntelOneMono:size=13";
        login-shell = "yes";
        resize-by-cells = "no";
      };

      colors.alpha = if config.theme.oled then "1.0" else "0.85";
    };
  };
}
