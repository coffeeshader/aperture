{ config, ... }:

{
  programs.keepassxc = {
    enable = true;
    autostart = true;

    settings = {
      General.ConfigVersion = 2;

      GUI = {
        ApplicationTheme = "classic";
        ShowTrayIcon = true;
        MinimizeToTray = true;
        MinimizeOnStartup = true;
        MinimizeOnClose = true;
      };

      Browser = {
        Enabled = true;
        UpdateBinaryPath = false;
      };

      Security.LockDatabaseIdle = false;
      SSHAgent.Enabled = true;

      FdoSecrets = {
        Enabled = true;
        UnlockBeforeSearch = true;
      };
    };
  };

  browser.nativeMessagingHosts = [ config.programs.keepassxc.package ];

  xdg.mimeApps.defaultApplications."application/x-keepass2" = "org.keepassxc.KeePassXC.desktop";
}
