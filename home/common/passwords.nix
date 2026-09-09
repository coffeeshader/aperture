{ config, ... }:

{
  programs.keepassxc = {
    enable = true;

    settings = {
      General.ConfigVersion = 2;
      GUI.ApplicationTheme = "classic";

      Browser = {
        Enabled = true;
        UpdateBinaryPath = false;
      };

      SSHAgent.Enabled = true;
    };
  };

  browser.nativeMessagingHosts = [ config.programs.keepassxc.package ];

  xdg.mimeApps.defaultApplications."application/x-keepass2" = "org.keepassxc.KeePassXC.desktop";
}
