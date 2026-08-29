{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.catppuccin) flavor;

  themeName = "catppuccin-${flavor}";

  mocha = {
    base = "1e1e2e";
    mantle = "181825";
    crust = "11111b";
    text = "cdd6f4";
    overlay0 = "6c7086";
    mauve = "cba6f7";
    lavender = "b4befe";
    sky = "89dceb";
    yellow = "f9e2af";
    teal = "94e2d5";
    sapphire = "74c7ec";
    blue = "89b4fa";
    pink = "f5c2e7";
    maroon = "eba0ac";
    red = "f38ba8";
    green = "a6e3a1";
  };

  p = lib.throwIf (flavor != "mocha") "rmpc theme colors are hardcoded for mocha, got ${flavor}" (
    (
      mocha // lib.optionalAttrs config.theme.oled (config.theme.oledColors |> lib.mapAttrs (_: c: c.to))
    )
    |> lib.mapAttrs (_: hex: "#${hex}")
  );

  band = "#${mocha.mantle}";

  theme = pkgs.writeText "${themeName}.ron" ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    #![enable(unwrap_variant_newtypes)]
    (
        default_album_art_path: None,
        draw_borders: false,
        show_song_table_header: false,
        symbols: (song: "󰝚", dir: "󰀥", playlist: "󰲸", marker: "\u{e0b0}"),
        layout: Split(
            direction: Vertical,
            panes: [
                (pane: Pane(Header),      size: "1"),
                (pane: Pane(TabContent),  size: "100%"),
                (pane: Pane(ProgressBar), size: "1"),
            ],
        ),
        progress_bar: (
            symbols: ["━", "━", "⭘", " ", " "],
            track_style:   (bg: "${band}"),
            elapsed_style: (fg: "${p.mauve}", bg: "${band}"),
            thumb_style:   (fg: "${p.mauve}", bg: "${band}"),
        ),
        scrollbar: (
            symbols: ["│", "█", "▲", "▼"],
            track_style: (),
            ends_style: (),
            thumb_style: (fg: "${p.lavender}"),
        ),
        browser_column_widths: [20, 38, 42],
        text_color: "${p.text}",
        background_color: "${p.base}",
        header_background_color: "${band}",
        modal_background_color: None,
        modal_backdrop: false,
        tab_bar: (active_style: (fg: "black", bg: "${p.mauve}", modifiers: "Bold"), inactive_style: ()),
        borders_style: (fg: "${p.overlay0}"),
        highlighted_item_style: (fg: "${p.mauve}", modifiers: "Bold"),
        current_item_style: (fg: "black", bg: "${p.lavender}", modifiers: "Bold"),
        highlight_border_style: (fg: "${p.lavender}"),
        song_table_format: [
            (
                prop: (kind: Property(Artist), style: (fg: "${p.lavender}"), default: (kind: Text("Unknown"))),
                width: "50%",
                alignment: Right,
            ),
            (
                prop: (kind: Text("-"), style: (fg: "${p.lavender}"), default: (kind: Text("Unknown"))),
                width: "1",
                alignment: Center,
            ),
            (
                prop: (kind: Property(Title), style: (fg: "${p.sky}"), default: (kind: Text("Unknown"))),
                width: "50%",
            ),
        ],
        header: (
            rows: [
                (
                    left: [
                        (kind: Text("["), style: (fg: "${p.lavender}", modifiers: "Bold")),
                        (kind: Property(Status(State)), style: (fg: "${p.lavender}", modifiers: "Bold")),
                        (kind: Text("]"), style: (fg: "${p.lavender}", modifiers: "Bold"))
                    ],
                    center: [
                        (kind: Property(Song(Artist)), style: (fg: "${p.yellow}", modifiers: "Bold"),
                            default: (kind: Text("Unknown"), style: (fg: "${p.yellow}", modifiers: "Bold"))
                        ),
                        (kind: Text(" - ")),
                        (kind: Property(Song(Title)), style: (fg: "${p.sky}", modifiers: "Bold"),
                            default: (kind: Text("No Song"), style: (fg: "${p.sky}", modifiers: "Bold"))
                        )
                    ],
                    right: [
                        (kind: Text("Vol: "), style: (fg: "${p.lavender}", modifiers: "Bold")),
                        (kind: Property(Status(Volume)), style: (fg: "${p.lavender}", modifiers: "Bold")),
                        (kind: Text("% "), style: (fg: "${p.lavender}", modifiers: "Bold"))
                    ]
                )
            ],
        ),
        level_styles: (
            info:  (fg: "${p.mauve}",    bg: "${p.base}"),
            warn:  (fg: "${p.yellow}",   bg: "${p.base}"),
            error: (fg: "${p.red}",      bg: "${p.base}"),
            debug: (fg: "${p.green}",    bg: "${p.base}"),
            trace: (fg: "${p.lavender}", bg: "${p.base}"),
        ),
        cava: (
            bar_symbols: ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'],
            inverted_bar_symbols: ['▔', '🮂', '🮃', '▀', '🮄', '🮅', '🮆', '█'],
            bar_width: 1,
            bar_spacing: 1,
            orientation: Horizontal,
            bar_color: Gradient({
                12: "${p.teal}",
                25: "${p.sky}",
                36: "${p.sapphire}",
                50: "${p.blue}",
                60: "${p.mauve}",
                75: "${p.pink}",
                84: "${p.maroon}",
                100: "${p.red}",
            }),
        ),
    )
  '';
in
{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    playlistDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      replaygain "auto"

      audio_output {
        type "pipewire"
        name "PipeWire"
      }
    '';
  };

  services.mpd-mpris.enable = true;

  programs.rmpc = {
    enable = true;
    config = ''
      #![enable(implicit_some)]
      #![enable(unwrap_newtypes)]
      #![enable(unwrap_variant_newtypes)]
      (
        theme: Some("${themeName}"),
        tabs: [
            (
                name: "Queue",
                pane: Split(
                    direction: Horizontal,
                    panes: [(size: "60%", pane: Pane(Queue)), (size: "40%", pane: Pane(AlbumArt))],
                ),
            ),
            (name: "Directories",   pane: Pane(Directories)),
            (name: "Artists",       pane: Pane(Artists)),
            (name: "Album Artists", pane: Pane(AlbumArtists)),
            (name: "Albums",        pane: Pane(Albums)),
            (name: "Playlists",     pane: Pane(Playlists)),
            (name: "Search",        pane: Pane(Search)),
        ],
      )
    '';
  };

  xdg.configFile."rmpc/themes/${themeName}.ron".source = theme;

  xdg.desktopEntries.rmpc = {
    name = "rmpc";
    exec = "ghostty -e rmpc";
    terminal = false;
  };
}
