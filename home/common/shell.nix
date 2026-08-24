{
  pkgs,
  config,
  lib,
  ...
}:

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
      nrs = "doas nixos-rebuild switch --flake ~/aperture";
      ff = "fastfetch";
    };

    plugins = with pkgs.nushellPlugins; [
      formats
      query
      gstat
    ];

    environmentVariables = {
      RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/ripgrep/rg.conf";

      PROMPT_COMMAND = lib.hm.nushell.mkNushellInline ''
        {||
          let pwd = ($env.PWD | str replace $env.HOME "~")
          let host = (sys host | get hostname | split row "." | first)
          $"(ansi cyan_bold)($env.USER)(ansi yellow_bold)@(ansi magenta_bold)($host)(ansi reset) (ansi red)($pwd)(ansi reset) "
        }
      '';
      PROMPT_INDICATOR = "";
      PROMPT_INDICATOR_VI_INSERT = "";
      PROMPT_INDICATOR_VI_NORMAL = ": ";
    };
  };

  xdg.configFile."yash/profile".source = ../dotfiles/yash/profile;
}
