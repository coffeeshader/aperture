{ inputs, pkgs, ... }:

{
  nix.registry.aperture.flake = inputs.self;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."coffeeshader" = {
    isNormalUser = true;
    description = "Helder Rodrigues";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.yash;
    packages = with pkgs; [ ];
  };

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
  };

  environment.shells = [ pkgs.yash ];

  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
  ];

  # Use run0 instead of sudo
  security = {
    sudo.enable = false;

    run0 = {
      enable = true;
      persistentAuth.enable = true;
    };
  };

  system.tools.nixos-rebuild.enableRun0Elevation = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
