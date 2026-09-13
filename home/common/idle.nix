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

    dimCommand = lib.mkOption {
      type = lib.types.str;
      description = "Command that dims the screen";
    };
    undimCommand = lib.mkOption {
      type = lib.types.str;
      description = "Command that restores the screen after dimming";
    };
    screenOffCommand = lib.mkOption {
      type = lib.types.str;
      description = "Command that powers off the screen";
    };
    screenOnCommand = lib.mkOption {
      type = lib.types.str;
      description = "Command that powers the screen back on";
    };
  };
}
