{ pkgs, ... }:

{
  # Also enabled by programs.steam
  hardware.steam-hardware.enable = true;

  #XR_RUNTIME_JSON=<monado>/share/openxr/1/openxr_monado.json
  services.monado = {
    enable = true;
    defaultRuntime = false;
  };
}
