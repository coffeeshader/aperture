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
    description = "Packages providing native messaging hosts to install for Helium";
  };

  config = {
    home.packages = [ helium ];

    xdg.configFile."net.imput.helium/NativeMessagingHosts" = {
      enable = nativeMessagingHosts != [ ];
      source = "${manifests}/etc/chromium/native-messaging-hosts";
      recursive = true;
    };
  };
}
