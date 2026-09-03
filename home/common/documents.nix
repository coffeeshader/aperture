{ ... }:

{
  programs.sioyek = {
    enable = true;

    config = {
      should_load_tutorial_when_no_other_file = "0";
      collapsed_toc = "1";
      ui_font = "Intel One Mono";
      should_launch_new_window = "1";
      startup_commands = [ "toggle_custom_color" ];
    };

    bindings = {
      move_up = "k";
      move_down = "j";
      move_left = "h";
      move_right = "l";
    };
  };

  xdg.mimeApps.defaultApplications."application/pdf" = "sioyek.desktop";
}
