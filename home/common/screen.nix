{ lib, ... }:

{
  options.screen = {
    width = lib.mkOption {
      type = lib.types.ints.positive;
      description = "Logical (post-scaling) screen width";
    };
    height = lib.mkOption {
      type = lib.types.ints.positive;
      description = "Logical (post-scaling) screen height";
    };
  };
}
