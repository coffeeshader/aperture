{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [ inputs.millennium.overlays.default ];

  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam;
    extraCompatPackages = [ pkgs.proton-ge-bin ];

    remotePlay.openFirewall = false;
    gamescopeSession.enable = false;

    extest.enable = true;
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

  environment.systemPackages = with pkgs; [
    mangohud
    vulkan-tools
  ];
}
