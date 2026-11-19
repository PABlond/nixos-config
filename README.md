# NixOS configuration -- host `nixos`

Flake-based, version-controlled system configuration. Covers the system **and**
the user's dotfiles, so a reinstall needs no file copied by hand.

## Machine

| | |
|---|---|
| Host | `nixos` |
| NixOS | 26.05 (Yarara) |
| CPU | AMD |
| GPU | NVIDIA RTX 2080, proprietary driver, `open` kernel modules |
| Disks | `nvme0n1` NixOS (shared ESP) · `sda` Windows 11 (dual boot) |
| Desktop | Sway (Wayland) via SDDM, with an i3/X11 rescue session |
| Monitors | 2 × Samsung C27F390 1080p, stacked vertically |
| Keyboard | `fr`, `caps:escape` |

## Layout

```
flake.nix                    inputs and the nixosConfigurations output
flake.lock                   pinned nixpkgs revision -- the source of truth
configuration.nix            entry point -- imports only
hardware-configuration.nix   generated, machine-specific, do not hand-edit
modules/                     one file per domain
dotfiles/                    user config, placed by modules/home.nix
wallpapers/                  images; the desktop background is picked in modules/home.nix
```

## Applying

```sh
sudo nixos-rebuild switch --flake /home/alex/dev/nixos-config#nixos
```

Aliased to `rebuild` in the zsh config. It applies the system and the dotfiles
in one pass -- there is no separate `home-manager switch`.

Flakes only see **git-tracked** files. A new module that was never `git add`ed
is invisible to the build, and the error does not say so clearly. Stage first.

## Dotfiles

Managed by home-manager, running as a NixOS module (see `modules/home.nix`).
Files are placed two different ways, chosen per file:

| Idiom | Result |
|---|---|
| `.source = ../dotfiles/x` | copied into the store, read-only; a change needs a rebuild |
| `mkOutOfStoreSymlink` | symlink to the live file in this repo; editable, no rebuild |

`dotfiles/sway/config` uses the second one, because the window manager config
gets tuned often and `$mod+Shift+C` should keep working. The cost: it is
referenced by **absolute path** (`/home/alex/dev/nixos-config`), so cloning the
repo anywhere else leaves a dangling symlink and Sway falls back to the stock
`/etc/sway/config`. Everything else uses `.source` and survives the repo being
moved or deleted.

## Updating nixpkgs

```sh
nix flake update            # aliased to `update`; touches flake.lock only
rebuild
```

The branch name in `flake.nix` says where updates come from; `flake.lock` says
which revision is actually used. Nothing moves unless `flake.lock` moves, and a
bad update is undone with `git revert` of the lock commit.

That is the reason this repo is a flake. Under channels, `nix-channel --update`
took whatever upstream had just published -- which is how the Brave removal and
the VS Code breakage arrived unannounced in November 2026.

A lock bump can also move the **kernel**. When it does, `rebuild` alone leaves
the running kernel in place while out-of-tree modules (VirtualBox) are built
only for the new one: reboot rather than just logging out.

## Workarounds

None. There is no `overlays/` directory any more -- both November 2026
workarounds are gone, and the lesson from how they ended is worth keeping.

**`overlays/vscode-ripgrep.nix`**, removed 2026-11-19. It patched a path that VS
Code 1.144.0 had moved. Upstream resolved the bug by *reverting to 1.119.0*,
which restored the original path -- so the overlay then rewrote a correct path
into a nonexistent one and broke the build. Its own header had predicted that an
upstream fix would make it "silently inert"; that holds when upstream changes a
path, not when it reverts a version. A workaround keyed on a string that
reappears does not go quiet, it goes wrong.

**`overlays/brave.nix`**, removed 2026-11-19. Brave had been dropped from
nixpkgs because none of its maintainers held commit rights, which delayed
security fixes. It is back in the tree (1.99.57, with six maintainers), so both
the package and the reason it left are resolved.

The takeaway for the next one: write down the removal *condition*, check it
periodically, and do not assume a stale workaround fails safely.

## Reinstalling from scratch

`nixos-rebuild switch` from a live USB does **not** do this. It would rebuild
the live system in RAM and write nothing to disk. A fresh install is
`nixos-install`, and it needs two things this repo cannot carry: a regenerated
`hardware-configuration.nix`, and a password.

### Before touching anything

- **Leave `sda` alone.** It is the Windows 11 install.
- **Do not reformat `nvme0n1p1`.** It is the ESP, and it carries the Windows
  boot loader as well as systemd-boot -- `sda` has no EFI partition of its own.
  Formatting it makes Windows unbootable until a `bcdboot` repair.
- Only `nvme0n1p2` (root) and `nvme0n1p3` (swap) should be recreated.

### Procedure

```sh
# 1. Boot the NixOS installer ISO -- the graphical GNOME image is fine.
#    Its desktop is the installer's; it has nothing to do with this config
#    and nothing to "uninstall".

# 2. Format root and swap only, keeping the existing labels.
sudo mkfs.ext4 -L root /dev/nvme0n1p2
sudo mkswap -L swap /dev/nvme0n1p3

# 3. Mount, reusing the existing ESP without formatting it.
sudo mount /dev/disk/by-label/root /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1p1 /mnt/boot
sudo swapon /dev/disk/by-label/swap

# 4. Regenerate the hardware config -- the UUIDs in the committed one belong
#    to the old filesystems and will not exist any more.
sudo nixos-generate-config --root /mnt

# 5. Clone this repo to EXACTLY this path: dotfiles/sway/config is symlinked
#    by absolute path (see Dotfiles above).
sudo mkdir -p /mnt/home/alex/dev
sudo git clone https://github.com/PABlond/nixos-config.git \
    /mnt/home/alex/dev/nixos-config

# 6. Take the freshly generated hardware config over the committed one.
sudo cp /mnt/etc/nixos/hardware-configuration.nix \
    /mnt/home/alex/dev/nixos-config/

# 7. Install.
sudo nixos-install --flake /mnt/home/alex/dev/nixos-config#nixos

# 8. Set the password -- modules/users.nix declares none on purpose, this repo
#    holds no secrets. Without this there is no way to log in.
sudo nixos-enter --root /mnt -c 'passwd alex'

# 9. Fix ownership of the clone, then reboot.
sudo nixos-enter --root /mnt -c 'chown -R alex:users /home/alex/dev'
reboot
```

Only after that does `rebuild` become the right command.

### Making step 4 unnecessary

`hardware-configuration.nix` refers to filesystems by UUID, which is why it has
to be regenerated. The partitions already carry the labels `root` and `swap`, so
switching those entries to `/dev/disk/by-label/...` would make the file portable
across reinstalls. Not done here, because the file is generated and carries a
"do not modify" header -- a deliberate choice to keep, not an oversight.

## Dual boot

systemd-boot shares the ESP with the Windows loader and discovers it
automatically. To skip the menu entirely:

```sh
sudo systemctl reboot --boot-loader-entry=auto-windows
```

See the reinstall warnings above before ever reformatting that partition.

## Secrets

None in this repository. Should the need arise (keys, tokens), use `sops-nix`
or `agenix` -- never a plaintext value, not even in a private repository.
