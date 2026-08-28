{
  pkgs,
  config,
  lib,
  ...
}:

let
  hmSessionVars = ''
    if [ -f "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh" ]; then
      . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
    fi
  '';
in
{
  programs.nushell = {
    enable = true;

    settings = {
      edit_mode = "vi";
      show_banner = false;
      history = {
        max_size = 5000;
        file_format = "sqlite";
      };
    };

    shellAliases = {
      nrs = "nixos-rebuild switch --flake ~/aperture --elevate=run0";
      ff = "fastfetch";
    };

    extraConfig = ''
      def --wrapped dev [environment: string, ...args: string] {
        let environments = ["rust" "c" "zig" "odin" "java"]
        if $environment not-in $environments {
          error make {
            msg: $"unknown environment '($environment)', expected one of: ($environments | str join ', ')"
          }
        }
        if ($args | is-empty) {
          nix shell $"aperture#($environment)" --command nu
        } else {
          nix shell $"aperture#($environment)" --command ...$args
        }
      }
    '';

    plugins = [
      pkgs.nushellPlugins.formats
      pkgs.nushellPlugins.query
      pkgs.nushellPlugins.gstat
    ];

    environmentVariables = {
      RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/ripgrep/rg.conf";

      PROMPT_COMMAND = lib.hm.nushell.mkNushellInline ''
        {||
          let pwd = ($env.PWD | str replace $env.HOME "~")
          let host = (sys host | get hostname | split row "." | first)
          let colors = $env.config.color_config

          $"(ansi { fg: $colors.shape_operator attr: b })($env.USER)(ansi { fg: $colors.shape_filepath attr: b })@(ansi { fg: $colors.shape_keyword attr: b })($host)(ansi reset) (ansi { fg: $colors.shape_garbage })($pwd)(ansi reset) "
        }
      '';
      PROMPT_INDICATOR = "";
      PROMPT_INDICATOR_VI_INSERT = "";
      PROMPT_INDICATOR_VI_NORMAL = ": ";
    };
  };

  xdg.configFile."yash/profile".text = hmSessionVars;

  xdg.configFile."yash/rc".text = hmSessionVars + ''

    if command -v nu >/dev/null 2>&1 && [ "$(ps -o comm= -p $PPID)" != "nu" ]; then
      exec nu
    fi
  '';
}
