# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, config, ... }:

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
    addKeysToAgent = "yes";

    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519_sk_ciri";
      };
      "git.sr.ht" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519_sk_ciri";
      };
      "codeberg.org" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519_sk_ciri";
      };
    };
  };

  programs.bash = {
    enable = true;
    shellAliases.nrs = "doas nixos-rebuild switch --flake ~/aperture";
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs: with epkgs; [
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

      (treesit-grammars.with-grammars (grammars: with grammars; [
        tree-sitter-rust
        tree-sitter-java
        tree-sitter-odin
        tree-sitter-zig
        tree-sitter-c
        tree-sitter-python
      ]))
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
  ];
}
