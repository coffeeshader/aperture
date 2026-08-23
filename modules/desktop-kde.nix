# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
services = {
	xserver.enable = false;

	displayManager = {
	    plasma-login-manager.enable = true;
            defaultSession = "plasma";
	};

	desktopManager.plasma6.enable = true;
};

environment.plasma6.excludePackages = with pkgs.kdePackages; [
	elisa
	okular
	khelpcenter
	print-manager
	plasma-browser-integration
	krdp
];
}
