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

    programs.claude-code = {
      enable = true;
      configDir = "${config.xdg.configHome}/claude";
    };

    programs.codex = {
      enable = true;

      settings = {
        approval_policy = "on-request";
        sandbox_mode = "workspace-write";

        analytics.enabled = false;
        feedback.enabled = false;

        sandbox_workspace_write.writable_roots = sandboxWritableRoots;

        otel = {
          exporter = "none";
          metrics_exporter = "none";
          trace_exporter = "none";
          log_user_prompt = false;
        };
      };
    };
  };
}
