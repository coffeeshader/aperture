{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ----- toolchains -----
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
  ];

  home.sessionVariables.JAVA_HOME = "${pkgs.jdk}/lib/openjdk";
}
