{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.streamrip.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace streamrip/client/qobuz.py \
          --replace-fail \
            'raise IneligibleError("Free accounts are not eligible to download tracks.")' \
            'logger.warning("No streaming plan; only purchased tracks will download")'

        substituteInPlace streamrip/client/qobuz.py \
          --replace-fail 'import hashlib' \
            'import hashlib
        import http.client
        http.client._MAXHEADERS = 1000'
      '';
    }))
  ];

  programs.beets = {
    enable = true;

    package = pkgs.python3Packages.toPythonApplication (
      (pkgs.python3Packages.beets-minimal.override {
        pluginOverrides = {
          musicbrainz.enable = true;
          scrub.enable = true;
          lastgenre.enable = true;
          replaygain.enable = true;
          lyrics.enable = true;
          mpdupdate.enable = true;
        };
      }).overridePythonAttrs
        (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace beets/util/lyrics.py \
              --replace-fail \
                'data = {"text": item.lyrics}' \
                'data = {"text": item.lyrics or ""}'

            substituteInPlace beetsplug/lyrics.py \
              --replace-fail \
                'return self.plain' \
                'return self.plain or ""'
          '';
        })
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

      musicbrainz = {
        host = "musicbrainz.org:443";
        https = true;
        ratelimit = 1;
        ratelimit_interval = 2;
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
