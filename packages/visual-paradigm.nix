{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  coreutils,
  gnused,
  gawk,
  which,
  openjdk,
}:

let
  version = "18.1";
  build = "20260913";
  runtimePath = lib.makeBinPath [
    coreutils
    gnused
    gawk
    which
  ];
in
stdenv.mkDerivation {
  pname = "visual-paradigm";
  version = "${version}.${build}";

  src = fetchurl {
    url = "https://eu10-dl.visual-paradigm.com/visual-paradigm/vp${version}/${build}/Visual_Paradigm_${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }_${build}_Linux64_InstallFree.tar.gz";
    hash = "sha256-5440ZL7/jND2JCsgwXF1NFWP6kA+loS6L90i8oW0yMY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D Application/resources/vpuml.png $out/share/icons/hicolor/512x512/apps/vpuml.png

    mkdir -p $out/{bin,share/visual-paradigm}
    mv {Application,.install4j} $out/share/visual-paradigm/

    substituteInPlace $out/share/visual-paradigm/Application/bin/Visual_Paradigm \
      --replace-fail '# INSTALL4J_JAVA_HOME_OVERRIDE=' "INSTALL4J_JAVA_HOME_OVERRIDE=${openjdk}" \
      --replace-fail 'app_home=../../' "app_home=${placeholder "out"}/share/visual-paradigm" \
      --replace-fail '\''${installer:sys.userHome}' '$HOME'
    makeWrapper $out/share/visual-paradigm/Application/bin/Visual_Paradigm $out/bin/Visual_Paradigm \
      --prefix PATH : ${runtimePath}

    runHook postInstall
  '';

  meta = {
    description = "UML CASE tool for software development";
    homepage = "https://www.visual-paradigm.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    mainProgram = "Visual_Paradigm";
  };
}
