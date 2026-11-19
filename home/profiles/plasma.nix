{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (config) idle;
  inherit (config.catppuccin) flavor accent;
  cursor = config.home.pointerCursor;

  idleProfile = suspend: {
    dimDisplay =
      if idle.dimAfter == null then
        { enable = false; }
      else
        {
          enable = true;
          idleTimeout = idle.dimAfter;
        };
    turnOffDisplay.idleTimeout = if idle.screenOffAfter == null then "never" else idle.screenOffAfter;
    autoSuspend =
      if suspend && idle.suspendAfter != null then
        {
          action = "sleep";
          idleTimeout = idle.suspendAfter;
        }
      else
        { action = "nothing"; };
  };
in
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = [ flavor ];
      accents = [ accent ];
    })
  ];

  xdg.configFile."plasma-workspace/env/hm-session-vars.sh".text = ''
    . ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh
  '';

  programs.plasma = {
    enable = true;

    workspace = {
      colorScheme = "Catppuccin${lib.toSentenceCase flavor}${lib.toSentenceCase accent}";
      iconTheme = "Papirus-Dark";
      clickItemTo = "open";
      wallpaper = "${config.home.homeDirectory}/Documents/Wallpapers/orange-clouds.jpg";
      cursor = {
        theme = cursor.name;
        inherit (cursor) size;
      };
    };

    input.keyboard.numlockOnStartup = "on";

    powerdevil = {
      AC = idleProfile (!idle.suspendOnBatteryOnly) // {
        powerProfile = "performance";
      };
      battery = idleProfile true // {
        powerProfile = "balanced";
      };
      lowBattery = idleProfile true;
    };

    kscreenlocker = {
      autoLock = idle.lockAfter != null;
      timeout = lib.mkIf (idle.lockAfter != null) ((idle.lockAfter + 59) / 60);
    };

    panels = [
      {
        location = "top";
        height = 46;
        floating = true;
        hiding = "autohide";
        alignment = "center";
        lengthMode = "fit";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          {
            iconTasks.launchers = [
              "applications:systemsettings.desktop"
              "preferred://filemanager"
              "applications:com.mitchellh.ghostty.desktop"
              "preferred://browser"
              "applications:emacsclient.desktop"
              "applications:vesktop.desktop"
              "applications:steam.desktop"
            ];
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.colorpicker"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    shortcuts = {
      "services/com.mitchellh.ghostty.desktop"._launch = "Meta+Return";
      "services/emacsclient.desktop"._launch = "Meta+E";
      "services/helium.desktop"._launch = "Meta+B";
      "services/rmpc.desktop"._launch = "Meta+M";
      "services/org.kde.krunner.desktop"._launch = [
        "Meta+Space"
        "Alt+Space"
        "Alt+F2"
        "Search"
      ];

      "services/org.kde.dolphin.desktop"._launch = [ ];

      org_kde_powerdevil.powerProfile = "Battery";
    };

    hotkeys.commands =
      let
        rmpc = lib.getExe config.programs.rmpc.package;
      in
      {
        rmpc-volume-down = {
          name = "Decrease rmpc volume";
          key = "Meta+;";
          command = "${rmpc} volume -5";
        };
        rmpc-volume-up = {
          name = "Increase rmpc volume";
          key = "Meta+'";
          command = "${rmpc} volume +5";
        };
        rmpc-toggle-pause = {
          name = "Toggle rmpc playback";
          key = "Meta+Shift+M";
          command = "${rmpc} togglepause";
        };
      };

    configFile = {
      kdeglobals.General = {
        TerminalApplication = "ghostty";
        TerminalService = "com.mitchellh.ghostty.desktop";
      };
      krunnerrc.Plugins = {
        baloosearchEnabled = false;
        krunner_appstreamEnabled = false;
        krunner_recentdocumentsEnabled = false;
        krunner_webshortcutsEnabled = false;
        krunner_bookmarksrunnerEnabled = false;
        krunner_sessionsEnabled = false;
        helprunnerEnabled = false;
      };
      kwinrc.Plugins.hidecursorEnabled = true;
      kwinrc."Effect-hidecursor" = {
        InactivityDuration = 3;
        HideOnTyping = true;
      };
    };
  };
}
