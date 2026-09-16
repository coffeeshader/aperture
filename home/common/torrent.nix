{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [ pkgs.qbittorrent ];

  home.activation.qbittorrentDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "${config.xdg.configHome}/qBittorrent/qBittorrent.conf" ]; then
      run ${pkgs.coreutils}/bin/install -Dm600 ${
        pkgs.writeText "qBittorrent.conf" ''
          [BitTorrent]
          Session\AnonymousModeEnabled=true
          Session\LSDEnabled=false

          [Network]
          PortForwardingEnabled=false

          [Preferences]
          WebUI\Enabled=false
        ''
      } "${config.xdg.configHome}/qBittorrent/qBittorrent.conf"
    fi
  '';
}
