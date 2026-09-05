{ config, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      window-decoration = "server";
      window-theme = "ghostty";
      window-padding-color = "extend";
      window-padding-balance = true;
      quit-after-last-window-closed = false;
      shell-integration-features = "ssh-env,ssh-terminfo";
      gtk-wide-tabs = false;
      font-family = "Intel One Mono";
      font-size = 14;
      background-opacity = if config.theme.oled then 1.0 else 0.85;

      keybind = [
        "performable:ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
      ];
    };
  };

  xdg.dataFile."nushell/vendor/autoload/ghostty.nu".source =
    "${config.programs.ghostty.package}/share/ghostty/shell-integration/nushell/vendor/autoload/ghostty.nu";

  xdg.configFile."nushell/autoload/ghostty.nu".text = ''
    $env.GHOSTTY_SHELL_FEATURES = ($env.GHOSTTY_SHELL_FEATURES? | default "")
    use ghostty *
  '';
}
