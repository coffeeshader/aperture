{ config, pkgs, ... }:
let
  sandboxWritableRoots = [
    "${config.home.homeDirectory}/.cargo"
    "${config.home.homeDirectory}/.m2/repository"
    "${config.home.homeDirectory}/.cache/zig"
  ];
in
{
  home.packages = with pkgs; [
    rustc
    cargo
    zig
    odin
    clang
    jdk
    maven

    rust-analyzer
    zls
    ols
    clang-tools
    jdt-language-server
    nil
    nixfmt

    bubblewrap
    socat
  ];

  home.sessionVariables.JAVA_HOME = "${pkgs.jdk}/lib/openjdk";

  programs.claude-code = {
    enable = true;

    settings = {
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
}
