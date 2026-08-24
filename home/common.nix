{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:

{

  imports = [
    ./development.nix
  ];

  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    settings = {
      core.editor = "emacs";

      user = {
        name = "Hélder Rodrigues";
        email = "me@shader.coffee";
        signingkey = "~/.ssh/id_ed25519_sk_ciri.pub";
      };

      push = {
        default = "simple";
        followTags = true;
      };

      sendmail.annotate = true;
      pull.rebase = true;
      init.defaultBranch = "master";

      commit = {
        verbose = true;
        gpgsign = true;
      };

      gpg = {
        format = "ssh";
        ssh = {
          allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
          defaultKeyCommand = "ssh-add -L";
        };
      };

      tag.gpgsign = true;
    };
  };

  xdg.configFile."git/allowed_signers".text = ''
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICNcdy7rKlx1Hgldb/JJInHDFK5IEk+XmGbsaNkds72iAAAABHNzaDo= me@shader.coffee
  '';

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      };
      "github.com" = {
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_sk_ciri";
      };
      "git.sr.ht" = {
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_sk_ciri";
      };
      "codeberg.org" = {
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_sk_ciri";
      };
    };
  };

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

  xdg.configFile."yash/profile".source = ./dotfiles/yash/profile;

  xdg.configFile."foot/foot.ini".source = ./dotfiles/foot/foot.ini;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages =
      epkgs: with epkgs; [
        dashboard
        catppuccin-theme
        company
        rust-mode
        zig-mode
        evil
        evil-surround
        evil-collection
        evil-org
        magit
        markdown-mode
        nix-mode

        (treesit-grammars.with-grammars (
          grammars: with grammars; [
            tree-sitter-rust
            tree-sitter-java
            tree-sitter-odin
            tree-sitter-zig
            tree-sitter-c
            tree-sitter-python
          ]
        ))
      ];
  };

  programs.vesktop = {
    enable = true;
    settings = {
      discordBranch = "stable";
      arRPC = true;
      tray = true;
      minimizeToTray = false;
      hardwareAccelaration = true;
    };
    vencord = {
      themes = {
        catppuccin-mocha = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/discord/refs/heads/main/themes/mocha.theme.css";
          hash = "sha256-XVD4Dqd3afVdO4MxJNqyVqmLrb6CmC6Km7uX9w0LIvE=";
        };
      };
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        enabledThemes = [ "catppuccin-mocha.css" ];
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

  services.emacs.enable = true;

  xdg.configFile."emacs/early-init.el".source = ./dotfiles/emacs/early-init.el;
  xdg.configFile."emacs/init.el".source = ./dotfiles/emacs/init.el;
  xdg.configFile."emacs/custom.el".source = ./dotfiles/emacs/custom.el;

  home.packages = with pkgs; [
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
    foot
    mpv
    yt-dlp
    btop
    fastfetch
  ];
}
