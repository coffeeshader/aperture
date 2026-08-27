{ pkgs, ... }:

{
  home.packages = [
    pkgs.yt-dlp
  ];

  programs.mpv = {
    enable = true;
    config = {
      vo = "gpu-next";
      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      hwdec = "auto-copy";
      save-position-on-quit = true;
    };
  };
}
