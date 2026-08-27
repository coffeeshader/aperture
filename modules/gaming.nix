{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [ inputs.millennium.overlays.default ];

  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam;
    extraCompatPackages = [ pkgs.proton-ge-bin ];

    gamescopeSession.enable = false;
    extest.enable = true;

    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;

    settings = {
      general = {
        renice = 11;
      };
    };
  };

  environment.sessionVariables.ENABLE_LAYER_MESA_ANTI_LAG = "1";
}
