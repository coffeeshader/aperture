{
  config,
  lib,
  pkgs,
  ...
}:
let
  devEnvironmentDirectory = "${config.home.homeDirectory}/.dev-env";
  sandboxWritableRoots = [
    "${devEnvironmentDirectory}/cargo"
    "${devEnvironmentDirectory}/maven/repository"
    "${devEnvironmentDirectory}/maven/wrapper"
    "${devEnvironmentDirectory}/zig/global-cache"
  ];
in
{
  home.packages = [
    pkgs.nil
    pkgs.nixfmt

    pkgs.bubblewrap
    pkgs.socat
  ];

  home.sessionVariables = {
    CARGO_HOME = "${devEnvironmentDirectory}/cargo";
    MAVEN_USER_HOME = "${devEnvironmentDirectory}/maven";
    MAVEN_ARGS = "--settings ${devEnvironmentDirectory}/maven/settings.xml";
    ZIG_GLOBAL_CACHE_DIR = "${devEnvironmentDirectory}/zig/global-cache";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.activation.createDevEnvironmentDirectories = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p ${lib.escapeShellArgs sandboxWritableRoots}
  '';

  home.file.".dev-env/maven/settings.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <settings xmlns="http://maven.apache.org/SETTINGS/1.2.0"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.2.0 https://maven.apache.org/xsd/settings-1.2.0.xsd">
      <localRepository>${devEnvironmentDirectory}/maven/repository</localRepository>
    </settings>
  '';

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
