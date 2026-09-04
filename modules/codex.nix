{
  config,
  pkgs,
  user,
  ...
}:

let
  inherit (config.home-manager.users.${user}.ai) sandboxWritableRoots;
in
{
  environment.etc."codex/requirements.toml".source =
    (pkgs.formats.toml { }).generate "codex-requirements.toml"
      {
        allowed_approval_policies = [ "on-request" ];

        allowed_sandbox_modes = [
          "workspace-write"
          "read-only"
        ];

        feedback.enabled = false;
      };

  environment.etc."codex/managed_config.toml".source =
    (pkgs.formats.toml { }).generate "codex-managed-config.toml"
      {
        analytics.enabled = false;

        sandbox_workspace_write.writable_roots = sandboxWritableRoots;

        otel = {
          exporter = "none";
          metrics_exporter = "none";
          trace_exporter = "none";
          log_user_prompt = false;
        };
      };
}
