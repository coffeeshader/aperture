{ ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = "IntelOneMono:size=11";
        login-shell = "yes";
        resize-by-cells = "no";
      };

      colors.alpha = "0.85";
    };
  };
}
