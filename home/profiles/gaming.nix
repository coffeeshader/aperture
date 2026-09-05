{ config, ... }:

let
  color = name: config.theme.palette.${name};
in
{
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
  };

  catppuccin.mangohud.enable = false;

  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    control=mangohud
    legacy_layout=0
    font_size=18
    font_scale_media_player=0.75
    background_color=000000
    background_alpha=0.8
    round_corners=10
    text_color=${color "text"}
    text_outline_color=${color "surface0"}
    offset_x=10
    offset_y=10
    gpu_list=0

    gpu_stats
    gpu_power
    gpu_color=${color "green"}
    cpu_stats
    cpu_power
    cpu_color=${color "blue"}
    ram
    ram_color=${color "pink"}
    fps
    fps_color_change=${color "red"},${color "yellow"},${color "green"}
    frametime=1
    frametime_color=${color "green"}
    frame_timing=1
    media_player
    media_player_name=mpd
    media_player_format={artist} - {title}
    media_player_color=${color "text"}
  '';
}
