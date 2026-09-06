{ inputs, pkgs, ... }:

{
  # autolith's sandbox probe runs /usr/bin/test to check that bwrap is executable
  systemd.tmpfiles.rules = [ "L+ /usr/bin/test - - - - ${pkgs.coreutils}/bin/test" ];

  nixpkgs.overlays = [
    (final: _prev: {
      autolith = import "${inputs.autolith}/nix/package.nix" {
        pkgs = final // {
          sbcl = final.sbcl_2_6_6;
          sbclPackages = final.sbcl_2_6_6.pkgs;
        };
        src = inputs.autolith;
      };
    })
  ];
}
