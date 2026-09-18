{ inputs, pkgs, ... }:

{
  # autolith's sandbox probe runs /usr/bin/test to check that bwrap is executable
  systemd.tmpfiles.rules = [ "L+ /usr/bin/test - - - - ${pkgs.coreutils}/bin/test" ];

  nixpkgs.overlays = [
    (final: _prev: {
      autolith =
        let
          src = final.applyPatches {
            name = "autolith-source";
            src = inputs.autolith;
            patches = [ ./patches/autolith-sbcl-minimum.patch ];
          };
        in
        import "${src}/nix/package.nix" {
          pkgs = final;
          inherit src;
        };
    })
  ];
}
