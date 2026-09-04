{ ... }:

{
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
  };

  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    control=mangohud
    legacy_layout=0
    horizontal
    hud_no_margin
    table_columns=14

    fps
    frametime=0
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
