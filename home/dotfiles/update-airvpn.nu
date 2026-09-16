#!/usr/bin/env nu

def main [config: path] {
  let config = ($config | path expand --strict)

  if ($config | path type) != "file" {
    error make {
      msg: "expected a WireGuard configuration file"
    }
  }

  ^run0 install -d -o root -g root -m 700 /etc/wireguard
  if $env.LAST_EXIT_CODE != 0 {
    exit $env.LAST_EXIT_CODE
  }

  ^run0 install -o root -g root -m 600 -- $config /etc/wireguard/airvpn.conf
  if $env.LAST_EXIT_CODE != 0 {
    exit $env.LAST_EXIT_CODE
  }

  print "Installed /etc/wireguard/airvpn.conf. Reconnect AirVPN to apply it."
}
