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

  imageTypes = [
    "image/png"
    "image/jpeg"
    "image/gif"
    "image/webp"
    "image/avif"
    "image/bmp"
    "image/svg+xml"
  ];

  helium-image = pkgs.writeShellApplication {
    name = "helium-image";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      src=$(realpath -- "$1")
      name=$(basename -- "$src")

      ext=''${name##*.}
      if [ "''${ext,,}" = svg ]; then
        img=image.svg; fit="s"
      else
        img=image; fit="Math.min(1, s)"
      fi

      dir=$(mktemp -d "''${XDG_RUNTIME_DIR:-/tmp}/helium-image.XXXXXX")
      ln -s -- "$src" "$dir/$img"

      title=''${name//&/&amp;}
      title=''${title//</&lt;}
      title=''${title//>/&gt;}

      cat > "$dir/index.html" <<EOF
      <!doctype html>
      <title>$title</title>
      <style>
      html, body { margin: 0; height: 100%; background: #${config.theme.paletteOled.crust}; }
      body { display: flex; }
      img { margin: auto; }
      </style>
      <img id="i" src="$img">
      <script>
      i.onload = () => {
        const s = Math.min(innerWidth / i.naturalWidth, innerHeight / i.naturalHeight);
        i.width = i.naturalWidth * ($fit);
      };
      </script>
      EOF

      exec ${lib.getExe helium} --incognito "--app=file://$dir/index.html"
    '';
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

    xdg.desktopEntries.helium-image = {
      name = "Helium Image Viewer";
      exec = "${lib.getExe helium-image} %f";
      mimeType = imageTypes;
      icon = "image-viewer";
      terminal = false;
      noDisplay = true;
    };

    xdg.mimeApps.defaultApplications = lib.genAttrs imageTypes (_: "helium-image.desktop");
  };
}
