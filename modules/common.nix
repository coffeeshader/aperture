{ inputs, pkgs, ... }:

{
  nix = {
    registry.aperture.flake = inputs.self;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      auto-optimise-store = true;
    };
  };

  programs.nh = {
    enable = true;
    flake = "/home/coffeeshader/aperture";

    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 14d";
    };
  };

  environment.sessionVariables.NH_ELEVATION_STRATEGY = "run0";

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Lisbon";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  users.users."coffeeshader" = {
    isNormalUser = true;
    description = "Hélder Rodrigues";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.yash;
  };

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
  };

  environment.shells = [ pkgs.yash ];

  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

  environment.systemPackages = [
    pkgs.vim
    pkgs.git
  ];

  fonts.packages = [ pkgs.intel-one-mono ];

  # Use run0 instead of sudo
  security = {
    sudo.enable = false;

    run0 = {
      enable = true;
      persistentAuth.enable = true;
    };
  };

  system.tools.nixos-rebuild.enableRun0Elevation = true;
}
