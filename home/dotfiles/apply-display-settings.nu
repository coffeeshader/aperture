const output = "DP-1"

def kscreen [...args: string] {
  let result = (^kscreen-doctor ...$args | complete)

  if $result.exit_code != 0 {
    error make {
      msg: ($result.stderr | str trim)
    }
  }

  $result.stdout
}

def main [] {
  let matches = (
    kscreen "--json"
    | from json
    | get outputs
    | where { |o| $o.name == $output and $o.connected and $o.enabled }
  )

  if ($matches | is-empty) {
    error make {
      msg: $"($output) is not connected"
    }
  }

  let monitor = ($matches | first)
  let mode = (
    $monitor.modes
    | where id == $monitor.currentModeId
    | first
  )

  let scale = match $mode.size.width {
    5120 => 1.3
    2560 => 1.0
    _ => {
      error make {
        msg: $"unsupported ($output) resolution: ($mode.size.width)x($mode.size.height)"
      }
    }
  }

  let settings = [
    $"scale.($scale)"
    "vrrpolicy.automatic"
    "hdr.enable"
    "wcg.enable"
    "sdr-brightness.250"
    "sdrGamut.50"
    "maxBrightnessOverride.560"
    "colorPowerTradeoff.preferAccuracy"
  ]

  kscreen ...($settings | each { |setting| $"output.($output).($setting)" }) | ignore

  print $"Set ($output) scale to ($scale) for ($mode.name) and re-applied VRR/HDR settings"
}
