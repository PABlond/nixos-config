# NixOS configuration -- host `nixos`

Version-controlled system configuration.

## Machine

| | |
|---|---|
| Host | `nixos` |
| NixOS | 26.05 (Yarara) |
| CPU | AMD |
| GPU | NVIDIA RTX 2080, proprietary driver, `open` kernel modules |
| Disks | `nvme0n1` NixOS (shared ESP) · `sda` Windows 11 (dual boot) |
| Desktop | GNOME / GDM, `fr` keyboard, `caps:escape` |

## Layout

```
configuration.nix            entry point -- imports only
hardware-configuration.nix   generated, do not hand-edit
modules/                     one file per domain
overlays/                    upstream workarounds, each self-documented
wallpapers/                  referenced by modules/desktop-gnome.nix
```

## Applying

```sh
sudo nixos-rebuild switch
```

## Temporary workarounds in place

Two November 2026 nixpkgs regressions. Both must be removed once upstream is
fixed; see the header of each file for the exact removal condition.

| File | Issue |
|---|---|
| `overlays/brave.nix` | Brave dropped from 26.05, [PR #584546](https://github.com/NixOS/nixpkgs/pull/584546) pending |
| `overlays/vscode-ripgrep.nix` | VS Code 1.144.0 build failure, [issue #584492](https://github.com/NixOS/nixpkgs/issues/584492) |

## Secrets

None in this repository. Should the need arise (keys, tokens), use `sops-nix`
or `agenix` -- never a plaintext value, not even in a private repository.
