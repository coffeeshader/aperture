{ ... }:

{
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
  };

  catppuccin.mangohud.enable = false;

  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    control=mangohud
    legacy_layout=0
    horizontal
    hud_no_margin
    horizontal_stretch=0
    table_columns=14
    font_size=18
    font_scale_media_player=1.0

    fps
    frametime=1
    frame_timing=1
    gpu_stats
    gpu_power
    cpu_stats
    cpu_power
    ram
    media_player
    media_player_name=mpd
    media_player_format={artist} - {title}
  '';
}
