{ pkgs }:

{
  c = pkgs.buildEnv {
    name = "c-environment";
    paths = [
      pkgs.clang
      pkgs.clang-tools
      pkgs.lld
    ];
  };

  rust = pkgs.buildEnv {
    name = "rust-environment";
    paths = [
      pkgs.rustc
      pkgs.cargo
      pkgs.rustfmt
      pkgs.clippy
      pkgs.rust-analyzer
    ];
  };

  zig = pkgs.buildEnv {
    name = "zig-environment";
    paths = [
      pkgs.zig
      pkgs.zls
    ];
  };

  odin = pkgs.buildEnv {
    name = "odin-environment";
    paths = [
      pkgs.odin
      pkgs.ols
    ];
  };

  java = pkgs.buildEnv {
    name = "java-environment";
    paths = [
      pkgs.jdk
      pkgs.maven
      pkgs.jdt-language-server
    ];
  };
}
