{ lib, pkgs, ... }:

let
  visualParadigm = pkgs.callPackage ../../packages/visual-paradigm.nix { };

  sandboxedVisualParadigm = pkgs.writeShellScriptBin "visual-paradigm" ''
    set -eu

    dir="$HOME/uni/bddad"
    mkdir -p "$dir/.config/VisualParadigm/tmp"

    exec ${lib.getExe pkgs.bubblewrap} \
      --unshare-user --unshare-pid --unshare-uts --unshare-cgroup \
      --die-with-parent --new-session \
      --ro-bind /nix/store /nix/store \
      --ro-bind /etc/static /etc/static \
      --ro-bind /etc/passwd /etc/passwd \
      --ro-bind /etc/group /etc/group \
      --ro-bind /etc/hosts /etc/hosts \
      --ro-bind /etc/resolv.conf /etc/resolv.conf \
      --ro-bind /etc/fonts /etc/fonts \
      --symlink /etc/static/zoneinfo /etc/zoneinfo \
      --symlink "$(readlink /etc/localtime)" /etc/localtime \
      --ro-bind-try /run/opengl-driver /run/opengl-driver \
      --dev /dev \
      --proc /proc \
      --tmpfs /tmp \
      --ro-bind /tmp/.X11-unix /tmp/.X11-unix \
      --tmpfs "$XDG_RUNTIME_DIR" \
      --bind "$dir" "$dir" \
      --setenv HOME "$dir" \
      --setenv XDG_CONFIG_HOME "$dir/.config" \
      --setenv XDG_CACHE_HOME "$dir/.cache" \
      --setenv XDG_DATA_HOME "$dir/.local/share" \
      --setenv XDG_STATE_HOME "$dir/.local/state" \
      --setenv _JAVA_AWT_WM_NONREPARENTING 1 \
      --setenv INSTALL4J_ADD_VM_PARAMS "-Duser.home=$dir" \
      -- ${lib.getExe visualParadigm} "$@"
  '';
in
{
  home.packages = [ sandboxedVisualParadigm ];

  xdg.desktopEntries.visual-paradigm = {
    name = "Visual Paradigm";
    genericName = "UML Modeling Tool";
    exec = "visual-paradigm %f";
    icon = "${visualParadigm}/share/icons/hicolor/512x512/apps/vpuml.png";
    terminal = false;
    categories = [ "Development" ];
  };
}
