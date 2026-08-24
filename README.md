# Aperture Science System Configuration

My NixOS configuration, as a flake.

## Layout

```
flake.nix          inputs and mkHost helper; one line per host
hosts/<name>/      hardware scan + per-host module selection
modules/           system modules (common incl. audio, KDE Plasma, gaming)
home/<name>.nix    per-host home entry (stateVersion)
home/common/       home-manager config, one file per topic (git, shell, emacs, ...)
home/plasma.nix    KDE-only plasma-manager config
```

## Hosts

- **glados** - x86_64 desktop running KDE Plasma 6 on nixos-unstable.
- **chell** - x86_64 laptop running Niri on nixos-unstable.

## Usage

Rebuild the system:

```sh
doas nixos-rebuild switch --flake ~/aperture
```

Format the Nix files:

```sh
nix fmt
```

## License

[MIT](LICENSE)
