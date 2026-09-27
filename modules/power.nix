{ config, ... }:

{
  services.watt = {
    enable = true;

    settings.rule = [
      {
        name = "plugged-in";
        priority = 0;

        cpu.governor = {
          "if".is-governor-available = "performance";
          "then" = "performance";
        };
        cpu.energy-performance-preference = {
          "if".is-energy-performance-preference-available = "performance";
          "then" = "performance";
        };
        cpu.turbo = {
          "if" = "?turbo-available";
          "then" = true;
        };
        power.platform-profile = {
          "if".is-platform-profile-available = "performance";
          "then" = "performance";
        };
        gpu.panel-power-savings = 0;
        audio.timeout-seconds = 0;
      }
      {
        name = "on-battery";
        priority = 10;
        "if" = "?discharging";

        cpu.governor = {
          "if".is-governor-available = "powersave";
          "then" = "powersave";
        };
        cpu.energy-performance-preference = {
          "if".is-energy-performance-preference-available = "power";
          "then" = "power";
        };
        cpu.turbo = {
          "if" = "?turbo-available";
          "then" = false;
        };
        power.platform-profile = {
          "if".is-platform-profile-available = "low-power";
          "then" = "low-power";
        };
        gpu.panel-power-savings = 3;
        audio.timeout-seconds = 1;
      }
    ];
  };

  systemd.services.watt = {
    environment.WATT_CONFIG = "/etc/watt.toml";
    restartTriggers = [ config.environment.etc."watt.toml".source ];
  };
}
