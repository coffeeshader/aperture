{
  config,
  lib,
  ...
}:

let
  inherit (config.devEnvironment) directory;
  inherit (config.ai) sandboxWritableRoots;
in
{
  options.ai.sandboxWritableRoots = lib.mkOption {
    internal = true;
    readOnly = true;
    type = lib.types.listOf lib.types.str;
    default = [
      "${directory}/cargo"
      "${directory}/maven/repository"
      "${directory}/maven/wrapper"
      "${directory}/zig/global-cache"
    ];
  };

  config = {
    home.activation.createSandboxWritableRoots = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p ${lib.escapeShellArgs sandboxWritableRoots}
    '';

    home.sessionVariables.CODEX_HOME = "${config.xdg.dataHome}/codex";

    home.activation.createCodexHome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p -m 700 ${lib.escapeShellArg "${config.xdg.dataHome}/codex"}
    '';

    programs.claude-code = {
      enable = true;
      configDir = "${config.xdg.dataHome}/claude";
    };

    programs.codex.enable = true;
  };
}
