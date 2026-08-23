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

    shortcuts = {
      "services/emacs.desktop"._launch = "Meta+E";
      "services/org.kde.dolphin.desktop"._launch = [ ];
      "services/foot.desktop"._launch = "Meta+Return";
    };

    configFile = {
      kwinrc.Windows_HDR.MaxLuminance = 560;
      kwinrc.Windows_HDR.Reference = 250;
      kdeglobals.General = {
        TerminalApplication = "foot";
        TerminalService = "foot.desktop";
      };
    };
  };
}
