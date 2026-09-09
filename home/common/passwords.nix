{ config, ... }:

{
  programs.keepassxc = {
    enable = true;
    autostart = true;

    settings = {
      General = {
        ConfigVersion = 2;
        AutoSaveAfterEveryChange = false;
        AutoSaveNonDataChanges = false;
      };

      GUI = {
        ApplicationTheme = "classic";
        MinimizeOnStartup = true;
        MinimizeOnClose = true;
      };

      Browser = {
        Enabled = true;
        UpdateBinaryPath = false;
      };

      Security.LockDatabaseIdle = false;
      SSHAgent.Enabled = true;
    };
  };

  browser.nativeMessagingHosts = [ config.programs.keepassxc.package ];

  xdg.mimeApps.defaultApplications."application/x-keepass2" = "org.keepassxc.KeePassXC.desktop";
}
