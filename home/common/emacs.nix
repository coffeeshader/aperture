{
  config,
  lib,
  pkgs,
  ...
}:

{
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
        envrc

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

  services.emacs.enable = true;

  home.sessionVariables = {
    EDITOR = "emacsclient -c";
    VISUAL = "emacsclient -c";
  };

  xdg.configFile."emacs/early-init.el".source = ../dotfiles/emacs/early-init.el;
  xdg.configFile."emacs/init.el".source = ../dotfiles/emacs/init.el;
  xdg.configFile."emacs/custom.el".source = ../dotfiles/emacs/custom.el;

  xdg.configFile."emacs/theme.el".text = ''
    (setq catppuccin-flavor '${config.catppuccin.flavor})
  ''
  + lib.optionalString config.theme.oled (
    config.theme.oledColors
    |> lib.mapAttrsToList (name: c: "(catppuccin-set-color '${name} \"#${c.to}\")")
    |> lib.concatStringsSep "\n"
  );
}
