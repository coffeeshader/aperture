{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  inherit (config.browser) nativeMessagingHosts;

  helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;

  manifests = pkgs.symlinkJoin {
    name = "helium-native-messaging-hosts";
    paths = nativeMessagingHosts;
  };
in
{
  options.browser.nativeMessagingHosts = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    description = "Packages providing native messaging hosts to install for Helium and LibreWolf";
  };

  config = {
    home.packages = [ helium ];

    xdg.configFile."net.imput.helium/NativeMessagingHosts" = {
      enable = nativeMessagingHosts != [ ];
      source = "${manifests}/etc/chromium/native-messaging-hosts";
      recursive = true;
    };

    programs.librewolf = {
      enable = true;
      inherit nativeMessagingHosts;

      policies = {
        SanitizeOnShutdown = {
          Cache = true;
          Cookies = true;
          Downloads = true;
          FormData = true;
          History = true;
          Sessions = true;
          OfflineApps = true;
          SiteSettings = false;
          Locked = true;
        };

        ExtensionSettings."keepassxc-browser@keepassxc.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
          default_area = "navbar";
        };
      };
    };
  };
}
