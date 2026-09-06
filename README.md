# Aperture Science System Configuration

My NixOS configuration, as a flake.

## Layout

```
flake.nix          inputs and mkHost helper; one line per host
hosts/<name>/      hardware scan + per-host module selection
modules/           system modules (common, audio, syncthing, Hyprland, gaming, vr)
packages/          reusable flake packages; dev environments via nix shell aperture#<env>
home/<name>.nix    per-host home entry (stateVersion)
home/common/       home-manager config, one file per topic (git, shell, emacs, ...)
home/profiles/     opt-in bundles a host imports (hyprland, gaming, modding, library)
```

## Hosts

- **glados** - x86_64 desktop running Hyprland on nixos-unstable.
- **chell** - x86_64 laptop running Hyprland on nixos-unstable.

## Usage

Rebuild the system:

```sh
nh os switch
```

Or without nh:

```sh
nixos-rebuild switch --flake ~/aperture --elevate=run0
```

Format the Nix files:

```sh
nix fmt
```

## License

[MIT](LICENSE)
