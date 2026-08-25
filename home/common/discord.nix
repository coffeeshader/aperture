{ ... }:

{
  programs.vesktop = {
    enable = true;
    settings = {
      discordBranch = "stable";
      arRPC = true;
      tray = true;
      minimizeToTray = false;
      hardwareAccelaration = true;
    };
    vencord = {
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        plugins = {
          FakeNitro.enabled = true;
          AnonymiseFileNames.enabled = true;
          BetterGifPicker.enabled = true;
          BiggerStreamPreview.enabled = true;
          CallTimer.enabled = true;
          ClearURLs.enabled = true;
          FixYoutubeEmbeds.enabled = true;
          ForceOwnerCrown.enabled = true;
          oneko.enabled = true;
        };
      };
    };
  };
}
