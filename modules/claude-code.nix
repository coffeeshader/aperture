{ config, pkgs, ... }:

let
  inherit (config.home-manager.users."coffeeshader".ai) sandboxWritableRoots;
in
{
  environment.etc."claude-code/managed-settings.json".source =
    (pkgs.formats.json { }).generate "claude-code-managed-settings.json"
      {
        env = {
          DISABLE_TELEMETRY = "1";
          DISABLE_ERROR_REPORTING = "1";
          CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
        };

        cleanupPeriodDays = 14;

        attribution = {
          commit = "";
          pr = "";
        };

        permissions = {
          defaultMode = "default";
          disableBypassPermissionsMode = "disable";

          ask = [
            "Bash(dangerouslyDisableSandbox:true)"
          ];

          allow = [
            "Bash(git status)"
            "Bash(git diff *)"
            "Bash(git log *)"
          ];

          deny = [
            "Read(./.env)"
            "Read(./.env.*)"
            "Read(~/.ssh/**)"
            "Read(~/.cargo/credentials)"
            "Read(~/.cargo/credentials.toml)"
            "Read(~/.dev-env/cargo/credentials)"
            "Read(~/.dev-env/cargo/credentials.toml)"
          ];
        };

        sandbox = {
          enabled = true;
          failIfUnavailable = true;
          allowUnsandboxedCommands = true;

          filesystem.allowWrite = sandboxWritableRoots;

          network.allowedDomains = [
            "github.com"
            "api.github.com"
            "raw.githubusercontent.com"
            "codeload.github.com"
            "objects.githubusercontent.com"
            "release-assets.githubusercontent.com"

            "codeberg.org"
            "git.sr.ht"

            "cache.nixos.org"
            "channels.nixos.org"
            "releases.nixos.org"
            "search.nixos.org"

            "crates.io"
            "static.crates.io"
            "index.crates.io"
            "docs.rs"

            "ziglang.org"

            "repo.maven.apache.org"
            "repo1.maven.org"

            "developer.mozilla.org"
          ];
        };
      };
}
