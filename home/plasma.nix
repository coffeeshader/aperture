{ ... }:

{
  programs.plasma = {
    enable = true;

    workspace = {
      #lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";
      iconTheme = "breeze-dark";
      cursor.theme = "Breeze_Snow";
    };

    configFile = {
      kwinrc.Windows_HDR.MaxLuminance = 560;
      kwinrc.Windows_HDR.Reference = 250;
    };
  };
}
