{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.catppuccin) flavor;

  themeName = "catppuccin-${flavor}";

  subs =
    config.theme.oledColors
    |> lib.mapAttrsToList (
      _: c: {
        from = "#${c.from}";
        to = "#${c.to}";
      }
    );

  sedArgs = subs |> map (s: "-e 's/${s.from}/${s.to}/g'") |> lib.concatStringsSep " ";

  guardEre = subs |> map (s: s.from) |> lib.concatStringsSep "|";

  src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/BNDays27/catppuccin-rmpc/3f68a3a089eef111b8af8b284cf494403afe99b8/themes/${flavor}/${themeName}.ron";
    hash = "sha256-NAgAMa/bNxRDoVJa+IQvpQHBIWCqb+F9kmYl6jc25vo=";
  };

  theme =
    if config.theme.oled then
      pkgs.runCommand "${themeName}-oled.ron" { inherit src; } ''
        sed ${sedArgs} "$src" > "$out"

        if grep -qiE '${guardEre}' "$out"; then
          echo "oled substitution missed occurrences of the ${flavor} palette" >&2
          grep -oiE '${guardEre}' "$out" | sort | uniq -c >&2
          exit 1
        fi
      ''
    else
      src;
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
      (
        theme: Some("${themeName}"),
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
