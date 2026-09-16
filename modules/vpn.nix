{ pkgs, ... }:

let
  port = 11867;
in
{
  environment.systemPackages = [
    (pkgs.writers.writeNuBin "update-airvpn" (builtins.readFile ../home/dotfiles/update-airvpn.nu))
  ];

  networking.wg-quick.interfaces.airvpn = {
    configFile = "/etc/wireguard/airvpn.conf";
    autostart = false;
  };

  networking.firewall.interfaces.airvpn = {
    allowedTCPPorts = [ port ];
    allowedUDPPorts = [ port ];
  };
}
