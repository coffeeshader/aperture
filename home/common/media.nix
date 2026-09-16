{ pkgs, ... }:

{
  home.packages = [
    pkgs.ani-cli
    pkgs.yt-dlp
  ];

  programs.mpv = {
    enable = true;
    config = {
      profile = "high-quality";
      vo = "gpu-next";
      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      hwdec = "auto";
      save-position-on-quit = true;
      screenshot-directory = "~/Pictures/Screenshots/mpv";
      volume = 60;
      alang = "ja,en";
      slang = "en";
    };
  };
}
