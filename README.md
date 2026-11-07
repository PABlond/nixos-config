# NixOS configuration -- host `nixos`

Flake-based, version-controlled system configuration.

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
flake.nix                    inputs and the nixosConfigurations output
flake.lock                   pinned nixpkgs revision -- the source of truth
configuration.nix            entry point -- imports only
hardware-configuration.nix   generated, do not hand-edit
modules/                     one file per domain
overlays/                    upstream workarounds, each self-documented
wallpapers/                  referenced by modules/desktop-gnome.nix
```

## Applying

```sh
sudo nixos-rebuild switch --flake /home/alex/dev/nixos-config#nixos
```

Aliased to `rebuild` in the zsh config.

Flakes only see **git-tracked** files. A new module that was never `git add`ed
is invisible to the build, which produces a confusing error. Stage first.

## Updating nixpkgs

```sh
nix flake update            # aliased to `update`; touches flake.lock only
rebuild
```

The branch name in `flake.nix` says where updates come from; `flake.lock` says
which revision is actually used. Nothing moves unless `flake.lock` moves, and
a bad update is undone with `git revert` of the lock commit.

That is the reason this repo is a flake. Under channels, `nix-channel --update`
took whatever upstream had just published -- which is how the two workarounds
below arrived unannounced.

## Temporary workarounds in place

Both must be removed once upstream is fixed; see each file's header for the
exact removal condition.

| File | Issue |
|---|---|
| `overlays/brave.nix` | Brave dropped from 26.05, [PR #584546](https://github.com/NixOS/nixpkgs/pull/584546) pending |
| `overlays/vscode-ripgrep.nix` | VS Code 1.144.0 build failure, [issue #584492](https://github.com/NixOS/nixpkgs/issues/584492) |

## Dual boot

systemd-boot shares the ESP with the Windows loader and discovers it
automatically. To skip the menu entirely:

```sh
sudo systemctl reboot --boot-loader-entry=auto-windows
```

## Secrets

None in this repository. Should the need arise (keys, tokens), use `sops-nix`
or `agenix` -- never a plaintext value, not even in a private repository.
