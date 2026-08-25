{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.catppuccin) flavor accent;

  rgb =
    hex:
    [
      0
      2
      4
    ]
    |> map (i: builtins.substring i 2 hex |> lib.fromHexString |> toString)
    |> lib.concatStringsSep ", ";

  subs =
    config.theme.oledColors
    |> lib.mapAttrsToList (
      _: c: [
        {
          from = "#${c.from}";
          to = "#${c.to}";
        }
        {
          from = "rgba(${rgb c.from}";
          to = "rgba(${rgb c.to}";
        }
      ]
    )
    |> lib.concatLists;

  sedArgs = subs |> map (s: "-e 's/${s.from}/${s.to}/g'") |> lib.concatStringsSep " ";

  guardEre =
    subs
    |> map (s: s.from)
    |> lib.concatStringsSep "|"
    |> lib.replaceStrings [ "(" ] [ "\\(" ];

  themeName = "catppuccin-${flavor}-oled.theme";

  oledTheme =
    pkgs.runCommand "${themeName}.css"
      {
        src = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/discord/0d8c7aaea33c655bb9e4c93d352a28f3baa69a75/dist/catppuccin-${flavor}-${accent}.theme.css";
          hash = "sha256-KVv9vfqI+WADn3w4yE1eNsmtm7PQq9ugKiSL3EOLheI=";
        };
      }
      ''
        sed ${sedArgs} "$src" > "$out"

        if grep -qiE '${guardEre}' "$out"; then
          echo "oled substitution missed occurrences of the ${flavor} palette" >&2
          grep -oiE '${guardEre}' "$out" | sort | uniq -c >&2
          exit 1
        fi
      '';
in
{
  catppuccin.vesktop.enable = !config.theme.oled;

  programs.vesktop = {
    enable = true;
    settings = {
      discordBranch = "stable";
      arRPC = true;
      tray = true;
      minimizeToTray = false;
      hardwareAcceleration = true;
    };
    vencord = {
      themes = lib.mkIf config.theme.oled {
        ${themeName} = oledTheme;
      };
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        enabledThemes = lib.mkIf config.theme.oled [ "${themeName}.css" ];
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
