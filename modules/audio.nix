{ ... }:

{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    extraConfig.pipewire."10-allowed-rates"."context.properties"."default.clock.allowed-rates" = [
      44100
      48000
      88200
      96000
      176400
      192000
    ];
  };
}
