{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./ssh.nix
    ./shell.nix
    ./terminal.nix
    ./emacs.nix
    ./discord.nix
    ./browser.nix
    ./media.nix
    ./development.nix
    ./graphics.nix
  ];

  xdg.enable = true;

  home.packages = with pkgs; [
    btop
    fastfetch
  ];
}
