{ pkgs, ... }:

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
      themes = {
        catppuccin-mocha = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/discord/refs/heads/main/themes/mocha.theme.css";
          hash = "sha256-XVD4Dqd3afVdO4MxJNqyVqmLrb6CmC6Km7uX9w0LIvE=";
        };
      };
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        enabledThemes = [ "catppuccin-mocha.css" ];
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
