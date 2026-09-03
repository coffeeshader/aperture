{ config, lib, ... }:

{
  options.repo.root = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/aperture";
    description = "Absolute path to the checked-out aperture repository";
  };
}
