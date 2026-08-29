#!/usr/bin/env nu

def name-key [name: string] {
  $name
  | str replace --all --regex r#'[\p{P}+]'# ' '
  | str trim
  | str replace --regex r#'(?i)^(the |an |a )'# ''
  | str lowercase
}

def main [playlist: path] {
  let playlist = ($playlist | path expand --strict)
  let sorted = (
    open --raw $playlist
    | lines --skip-empty
    | where {|entry| not ($entry | str starts-with '#') }
    | each {|entry|
        let parsed = ($entry | path parse)
        let album = ($parsed.parent | path basename)

        {
          entry: $entry
          album: (name-key $album)
          artist: ($parsed.parent | path dirname)
          track: $parsed.stem
        }
      }
    | sort-by --natural --ignore-case album artist track
    | get entry
    | str join (char nl)
    | $in + (char nl)
  )

  $sorted | save --force $playlist
}
