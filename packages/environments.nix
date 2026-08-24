{ pkgs }:

{
  c = pkgs.buildEnv {
    name = "c-environment";
    paths = with pkgs; [
      clang
      clang-tools
      lld
    ];
  };

  rust = pkgs.buildEnv {
    name = "rust-environment";
    paths = with pkgs; [
      rustc
      cargo
      rustfmt
      clippy
      rust-analyzer
    ];
  };


  zig = pkgs.buildEnv {
    name = "zig-environment";
    paths = with pkgs; [
      zig
      zls
    ];
  };

  odin = pkgs.buildEnv {
    name = "odin-environment";
    paths = with pkgs; [
      odin
      ols
    ];
  };

  java = pkgs.buildEnv {
    name = "java-environment";
    paths = with pkgs; [
      jdk
      maven
      jdt-language-server
    ];
  };
}
