{ pkgs, ... }:

{
  imports = [
    ./idle.nix
    ./theme.nix
    ./git.nix
    ./ssh.nix
    ./shell.nix
    ./terminal.nix
    ./emacs.nix
    ./discord.nix
    ./browser.nix
    ./documents.nix
    ./files.nix
    ./media.nix
    ./music.nix
    ./development.nix
    ./graphics.nix
  ];

  xdg.enable = true;

  home.packages = [
    pkgs.fastfetch
  ];

  programs.btop.enable = true;
}
