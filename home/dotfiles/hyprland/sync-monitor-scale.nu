#!/usr/bin/env nu

def main [] {
  let matches = (
    hyprctl -j monitors all
    | from json
    | where name == "DP-1"
  )

  if ($matches | is-empty) {
    error make {
      msg: "DP-1 is not connected"
    }
  }

  let monitor = ($matches | first)

  let scale = match $monitor.width {
    5120 => (4.0 / 3.0)
    2560 => 1.0
    _ => {
      error make {
        msg: $"unsupported DP-1 resolution: ($monitor.width)x($monitor.height)"
      }
    }
  }

  let monitor_rule = (
    'hl.monitor({ output = "DP-1", scale = SCALE })'
    | str replace "SCALE" ($scale | into string)
  )

  let result = (
    ^hyprctl eval $monitor_rule
    | complete
  )

  if $result.exit_code != 0 {
    error make {
      msg: ($result.stderr | str trim)
    }
  }

  let response = ($result.stdout | str trim)

  if $response != "ok" {
    error make {
      msg: $response
    }
  }

  print $"Set DP-1 scale to ($scale)"
}