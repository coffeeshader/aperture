# Aperture Science System Configuration

My NixOS configuration, as a flake.

## Layout

```
flake.nix          inputs and host definitions
hosts/             host-specific config + hardware scan
modules/           system modules (common, KDE Plasma, gaming, audio)
home/              home-manager config (shell, git, emacs, plasma, ...)
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
