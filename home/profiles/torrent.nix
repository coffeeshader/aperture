{
  config,
  lib,
  pkgs,
  ...
}:

let
  qbittorrentConfig = "${config.xdg.configHome}/qBittorrent/qBittorrent.conf";
  qbittorrentDefaults = pkgs.writeText "qbittorrent-defaults.conf" ''
    [BitTorrent]
    Session\AnonymousModeEnabled=true
    Session\BTProtocol=TCP
    Session\Interface=airvpn
    Session\InterfaceName=airvpn
    Session\LSDEnabled=false
    Session\Port=11867

    [Network]
    PortForwardingEnabled=false

    [Preferences]
    WebUI\Address=127.0.0.1
    WebUI\Enabled=true
    WebUI\Port=8080
    WebUI\LocalHostAuth=false
    WebUI\UseUPnP=false
  '';
  openQui = pkgs.writeShellScript "open-qui" ''
    set -eu

    ${pkgs.systemd}/bin/systemctl --user start qui.service
    ${lib.getExe pkgs.curl} \
      --fail --silent --show-error --noproxy '*' \
      --retry 30 --retry-connrefused --retry-delay 1 \
      --retry-max-time 30 --max-time 2 --output /dev/null \
      http://127.0.0.1:7476

    if [ "$#" -eq 0 ]; then
      exec ${pkgs.xdg-utils}/bin/xdg-open http://127.0.0.1:7476
    fi

    for magnet in "$@"; do
      url=$(${lib.getExe pkgs.jq} --null-input --raw-output --arg magnet "$magnet" \
        '"http://127.0.0.1:7476/add?magnet=" + ($magnet | @uri)')
      ${pkgs.xdg-utils}/bin/xdg-open "$url"
    done
  '';
in
{
  home.packages = [
    pkgs.qbittorrent-nox
    pkgs.qui
  ];

  systemd.user.services.qbittorrent = {
    Unit.Description = "qBittorrent backend for qui";

    Service = {
      ExecStartPre = pkgs.writeShellScript "configure-qbittorrent" ''
        set -eu

        if [ ! -e ${lib.escapeShellArg qbittorrentConfig} ]; then
          ${pkgs.coreutils}/bin/install -Dm600 ${qbittorrentDefaults} ${lib.escapeShellArg qbittorrentConfig}
        fi
      '';
      ExecStart = "${lib.getExe pkgs.qbittorrent-nox} --confirm-legal-notice";
      Environment = [
        "XDG_CONFIG_HOME=${config.xdg.configHome}"
        "XDG_DATA_HOME=${config.xdg.dataHome}"
      ];
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 1800;
      UMask = "0077";
    };
  };

  systemd.user.services.qui = {
    Unit = {
      Description = "qui web interface for qBittorrent";
      After = [ "qbittorrent.service" ];
      Wants = [ "qbittorrent.service" ];
    };

    Service = {
      ExecStartPre = "${lib.getExe pkgs.qui} generate-config --config-dir ${config.xdg.configHome}/qui";
      ExecStart = "${lib.getExe pkgs.qui} serve --config-dir ${config.xdg.configHome}/qui";
      Environment = [
        "QUI__HOST=127.0.0.1"
        "QUI__PORT=7476"
        "QUI__CHECK_FOR_UPDATES=false"
      ];
      Restart = "on-failure";
      RestartSec = 5;
      UMask = "0077";
    };
  };

  xdg.desktopEntries.qui = {
    name = "qui";
    genericName = "BitTorrent Client";
    exec = "${openQui} %U";
    terminal = false;
    mimeType = [ "x-scheme-handler/magnet" ];
    categories = [
      "Network"
      "FileTransfer"
      "P2P"
    ];
  };

  xdg.desktopEntries.qui-quit = {
    name = "Quit qui and local qBittorrent";
    exec = "${pkgs.systemd}/bin/systemctl --user stop qui.service qbittorrent.service";
    terminal = false;
    categories = [ "Network" ];
  };

  xdg.mimeApps.defaultApplications."x-scheme-handler/magnet" = [ "qui.desktop" ];
}
