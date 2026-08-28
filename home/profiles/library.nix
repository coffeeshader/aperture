{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.streamrip.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace streamrip/client/qobuz.py \
          --replace-fail \
            'raise IneligibleError("Free accounts are not eligible to download tracks.")' \
            'logger.warning("No streaming plan; only purchased tracks will download")'
      '';
    }))
  ];

  programs.beets = {
    enable = true;

    package = pkgs.python3Packages.toPythonApplication (
      pkgs.python3Packages.beets-minimal.override {
        pluginOverrides = {
          musicbrainz.enable = true;
          scrub.enable = true;
          lastgenre.enable = true;
          replaygain.enable = true;
          lyrics.enable = true;
          mpdupdate.enable = true;
        };
      }
    );

    mpdIntegration.enableUpdate = true;

    settings = {
      directory = "~/Music";
      library = "${config.xdg.dataHome}/beets/library.db";

      plugins = [
        "musicbrainz"
        "scrub"
        "lastgenre"
        "replaygain"
        "lyrics"
      ];

      import = {
        write = true;
        move = true;
        languages = "en";
        from_scratch = true;
      };

      lastgenre = {
        count = 3;
        force = true;
        whitelist = true;
        source = "album";
      };

      replaygain = {
        auto = true;
        backend = "ffmpeg";
        overwrite = true;
        per_disc = true;
      };

      lyrics = {
        fallback = "";
        sources = [ "lrclib" ];
        synced = true;
      };
    };
  };
}
