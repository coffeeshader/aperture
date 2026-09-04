{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.devEnvironment) directory;
in
{
  options.devEnvironment.directory = lib.mkOption {
    internal = true;
    readOnly = true;
    type = lib.types.str;
    default = "${config.home.homeDirectory}/.dev-env";
  };

  config = {
    home.packages = [
      pkgs.nil
      pkgs.nixfmt
    ];

    home.sessionVariables = {
      CARGO_HOME = "${directory}/cargo";
      MAVEN_USER_HOME = "${directory}/maven";
      MAVEN_ARGS = "--settings ${directory}/maven/settings.xml";
      ZIG_GLOBAL_CACHE_DIR = "${directory}/zig/global-cache";
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home.file.".dev-env/maven/settings.xml".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <settings xmlns="http://maven.apache.org/SETTINGS/1.2.0"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.2.0 https://maven.apache.org/xsd/settings-1.2.0.xsd">
        <localRepository>${directory}/maven/repository</localRepository>
      </settings>
    '';
  };
}
