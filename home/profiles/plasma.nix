{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  # Karousel's 50% preset = floor((tilingArea + innerGap)/2 - innerGap)
  outerGap = 16;
  innerGap = 8;
  tilingArea = config.screen.width - 2 * outerGap;
  halfWidth = (tilingArea + innerGap) / 2 - innerGap;
in
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  home.packages = [
    (pkgs.catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
    })
    (pkgs.catppuccin-papirus-folders.override {
      flavor = "mocha";
      accent = "mauve";
    })
    pkgs.kdePackages.karousel
    pkgs.kwin-script-geometry-change
    pkgs.kde-rounded-corners
  ];

  xdg.dataFile."kwin/scripts/focus-or-desktop".source = ../dotfiles/kwin/focus-or-desktop;

  programs.plasma = {
    enable = true;

    workspace = {
      colorScheme = "CatppuccinMochaMauve";
      iconTheme = "Papirus-Dark";
      # Change this later to a wallpaper in dotfiles/
      wallpaper = "${config.home.homeDirectory}/Documents/Wallpapers/orange-clouds.jpg";
      # catppuccin-mocha-mauve-cursors, from catppuccin.cursors in theme.nix
      cursor = {
        theme = config.home.pointerCursor.name;
        size = config.home.pointerCursor.size;
      };
    };

    powerdevil.AC.powerProfile = "performance";

    # niri-style vertical workspace stack: one desktop per row so
    # next/previous desktop (Meta+U/I) animates up/down
    kwin.virtualDesktops = {
      number = 9;
      rows = 9;
    };

    panels = [
      {
        location = "top";
        height = 46;
        floating = true;
        hiding = "autohide";
        alignment = "center";
        lengthMode = "custom";
        minLength = 1355;
        maxLength = 3879;
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
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    shortcuts = {
      # Launchers (niri: Mod+Return / Mod+E / Mod+B / Mod+Space)
      "services/com.mitchellh.ghostty.desktop"._launch = "Meta+Return";
      "services/org.kde.krunner.desktop"._launch = "Meta+Space";
      "services/emacsclient.desktop"._launch = "Meta+E";
      "services/rmpc.desktop"._launch = "Meta+M";
      "services/emacs.desktop"._launch = [ ];
      "services/helium.desktop"._launch = "Meta+B";
      "services/org.kde.dolphin.desktop"._launch = [ ];

      # Meta+L is focus-right, keep only the Screensaver key
      ksmserver."Lock Session" = "Screensaver";

      # Meta+B is the browser, keep only the Battery key
      org_kde_powerdevil.powerProfile = "Battery";

      plasmashell = {
        # Meta+V is toggle-floating
        "show-on-mouse-pos" = [ ];
        # Meta+Q is close-window
        "manage activities" = [ ];
      }
      # Meta+1..9 switch desktops instead of task manager entries
      // lib.mergeAttrsList (
        map (i: { "activate task manager entry ${toString i}" = [ ]; }) (lib.range 1 9)
      );

      kwin = {
        # Focus (niri: focus-column-left/right, focus-window-up/down)
        karousel-focus-left = [
          "Meta+Left"
          "Meta+H"
        ];
        karousel-focus-right = [
          "Meta+Right"
          "Meta+L"
        ];
        karousel-focus-up = "Meta+Up";
        karousel-focus-down = "Meta+Down";
        "focus-up-or-desktop" = "Meta+K";
        "focus-down-or-desktop" = "Meta+J";
        karousel-focus-start = "Meta+Home";
        karousel-focus-end = "Meta+End";

        # Move column/window (niri: move-column-left/right, move-window-up/down)
        karousel-column-move-left = [
          "Meta+Shift+Left"
          "Meta+Shift+H"
        ];
        karousel-column-move-right = [
          "Meta+Shift+Right"
          "Meta+Shift+L"
        ];
        karousel-window-move-up = [
          "Meta+Shift+Up"
          "Meta+Shift+K"
        ];
        karousel-window-move-down = [
          "Meta+Shift+Down"
          "Meta+Shift+J"
        ];
        karousel-column-move-start = "Meta+Shift+Home";
        karousel-column-move-end = "Meta+Shift+End";
        karousel-window-move-start = [ ];
        karousel-window-move-end = [ ];

        # In/out of columns (niri: consume-or-expel-window, Mod+[ and Mod+])
        karousel-window-move-left = "Meta+[";
        karousel-window-move-right = "Meta+]";

        karousel-cycle-preset-widths = "Meta+F";
        karousel-cycle-preset-widths-reverse = [ ];
        karousel-column-width-decrease = "Meta+-";
        karousel-column-width-increase = "Meta+=";
        # one-way, replaced by cycle-preset-widths above
        karousel-column-width-maximize = [ ];

        # niri: center-visible-columns (Mod+Ctrl+C)
        karousel-grid-scroll-focused = "Meta+Ctrl+C";

        # Workspaces -> virtual desktops (niri: Mod+PgDn/PgUp, Mod+U/I)
        "Switch to Next Desktop" = [
          "Meta+PgDown"
          "Meta+U"
        ];
        "Switch to Previous Desktop" = [
          "Meta+PgUp"
          "Meta+I"
        ];
        karousel-column-move-to-next-desktop = [
          "Meta+Ctrl+PgDown"
          "Meta+Ctrl+U"
        ];
        karousel-column-move-to-previous-desktop = [
          "Meta+Ctrl+PgUp"
          "Meta+Ctrl+I"
        ];

        # Window controls (niri: Mod+Q close, Mod+Shift+F fullscreen,
        # Mod+V floating, Mod+O overview)
        "Window Close" = [
          "Meta+Q"
          "Alt+F4"
        ];
        "Window Fullscreen" = "Meta+Shift+F";
        karousel-window-toggle-floating = "Meta+V";
        Overview = "Meta+O";

        # Unbind KWin defaults that collide with the binds above
        "Window Quick Tile Left" = [ ];
        "Window Quick Tile Right" = [ ];
        "Window Quick Tile Top" = [ ];
        "Window Quick Tile Bottom" = [ ];
        "Window Maximize" = [ ];
        "Window Minimize" = [ ];
        "Window to Next Screen" = [ ];
        "Window to Previous Screen" = [ ];
        view_zoom_in = [ ];
        view_zoom_out = [ ];
      }
      # Workspaces by number (niri: Mod+N focus, Mod+Ctrl+N move column);
      # frees Karousel's default Meta+N column focus
      // lib.mergeAttrsList (
        map (
          i:
          let
            n = toString i;
          in
          {
            "Switch to Desktop ${n}" = "Meta+${n}";
            "karousel-column-move-to-desktop-${n}" = "Meta+Ctrl+${n}";
            "karousel-focus-${n}" = [ ];
          }
        ) (lib.range 1 9)
      );
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

    window-rules = [
      {
        description = "always decorate";
        match.window-types = [ "normal" ];
        apply.noborder = {
          value = false;
          apply = "force";
        };
      }
      {
        description = "open at half screen width";
        match.window-class = {
          value = "^(?!ksshaskpass$)";
          type = "regex";
          match-whole = false;
        };
        match.window-types = [ "normal" ];
        apply.size = {
          value = "${toString halfWidth},${toString config.screen.height}";
          apply = "initially";
        };
      }
    ];

    configFile = {
      kwinrc.Plugins.karouselEnabled = true;
      kwinrc.Plugins.kwin4_effect_geometry_changeEnabled = true;
      kwinrc."Effect-kwin4_effect_geometry_change".Duration = 467;
      kwinrc.Plugins."focus-or-desktopEnabled" = true;
      kwinrc.Plugins.kwin4_effect_shapecornersEnabled = true;
      kwinrc."Round-Corners" = {
        AnimationDuration = 0;
        Size = 10;
        InactiveCornerRadius = 10;
        UseSquircleShape = false;
        OutlineThickness = 0;
        InactiveOutlineThickness = 0;
        SecondOutlineThickness = 0;
        InactiveSecondOutlineThickness = 0;
        OuterOutlineThickness = 3;
        ActiveOuterOutlineUsePalette = true;
        ActiveOuterOutlineUseCustom = false;
        DisableOutlineTile = false;
        DisableRoundTile = false;
      };
      # hidden titlebars via Breeze keep the decoration shadow the outer outline draws in
      kwinrc."org.kde.kdecoration2" = {
        BorderSize = "None";
        BorderSizeAuto = false;
      };
      breezerc."Windeco Exception 0" = {
        Enabled = true;
        ExceptionPattern = ".*";
        ExceptionType = 0;
        HideTitleBar = true;
        Mask = 0;
      };
      kwinrc.Windows_HDR.MaxLuminance = 560;
      kwinrc.Windows_HDR.Reference = 250;
      kdeglobals.General = {
        TerminalApplication = "ghostty";
        TerminalService = "com.mitchellh.ghostty.desktop";
      };
      kdeglobals.KDE.AnimationDurationFactor = 0.75;
    };
  };
}
