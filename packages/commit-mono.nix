{ lib, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "commit-mono-aperture";
  version = "1.143";

  src = ./commit-mono;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/opentype *.otf
    install -Dm644 -t $out/share/doc/commit-mono license.txt
    runHook postInstall
  '';

  meta = {
    description = "Commit Mono with custom settings from commitmono.com";
    homepage = "https://commitmono.com/";
    license = lib.licenses.ofl;
  };
}
