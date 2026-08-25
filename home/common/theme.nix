{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  options.theme = {
    oled = lib.mkEnableOption "OLED-optimized Catppuccin backgrounds";

    oledColors = lib.mkOption {
      internal = true;
      readOnly = true;
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
      default = {
        base = {
          from = "1e1e2e";
          to = "000000";
        };
        mantle = {
          from = "181825";
          to = "010101";
        };
        crust = {
          from = "11111b";
          to = "020202";
        };
      };
    };
  };

  config.catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "mauve";

    sources = lib.mkIf config.theme.oled (
      inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (
        _final: prev: {
          whiskers = pkgs.symlinkJoin {
            name = "whiskers-wrapped";
            paths = [ prev.whiskers ];
            nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
            postBuild =
              let
                overrides = builtins.toJSON {
                  ${config.catppuccin.flavor} = config.theme.oledColors |> lib.mapAttrs (_: c: c.to);
                };
              in
              ''
                wrapProgram $out/bin/whiskers \
                  --add-flag ${lib.escapeShellArg "--color-overrides=${overrides}"}
              '';
            meta.mainProgram = "whiskers";
          };
        }
      )
    );
  };
}
