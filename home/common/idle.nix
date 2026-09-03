{ lib, ... }:

{
  options.idle = {
    dimAfter = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = null;
      description = "Seconds of inactivity before dimming the screen";
    };
    screenOffAfter = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = null;
      description = "Seconds of inactivity before powering off the screen";
    };
    lockAfter = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = null;
      description = "Seconds of inactivity before locking the session";
    };
  };
}
