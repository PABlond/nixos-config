# home-manager: the user-level half of this configuration.
#
# Why this exists: until 2026-11-19 the system half of the desktop was
# declared here but every dotfile was a loose copy in ~/.config -- the sway
# config, alacritty.toml (hand-copied on 15 Sept, with two .bak files beside
# it), picom.conf. A reinstall would have restored a working Sway with none of
# its settings. That is the gap this closes.
#
# home-manager runs as a NixOS module, not standalone, so there is no separate
# `home-manager switch` to remember: `nixos-rebuild switch --flake .#nixos`
# does the system and the dotfiles in one pass. A reinstall is therefore
# `git clone` + one rebuild.
#
# Two ways to place a file, used deliberately:
#
#   .source = ./path            copies into the store -> read-only, immutable.
#                               Right for configs that are set and forgotten.
#
#   mkOutOfStoreSymlink <abs>   symlinks to the live file in this repo, so it
#                               stays editable and $mod+Shift+C reloads it with
#                               no rebuild. Right for the window manager config,
#                               which gets tuned often.
#
# The tradeoff is real and chosen per file, not globally: anything on
# mkOutOfStoreSymlink depends on this repo staying at the path below, whereas
# .source files survive even if the repo is deleted.

{ ... }:

let
  # mkOutOfStoreSymlink needs an absolute path to the working tree -- a
  # relative path would be copied into the store, which is the behaviour we
  # are avoiding here.
  repo = "/home/alex/dev/nixos-config";
in
{
  home-manager = {
    # Share the system's nixpkgs instead of the one pinned in home-manager's
    # own flake input. Without this there are two nixpkgs evaluations and user
    # packages can silently diverge from system ones.
    useGlobalPkgs = true;
    useUserPackages = true;

    # Move a conflicting pre-existing file aside instead of aborting the
    # rebuild. The dotfiles this module adopts are still sitting in ~/.config
    # as real files; the first switch will rename them to *.hm-bak.
    backupFileExtension = "hm-bak";

    # Takes its own `config`: mkOutOfStoreSymlink lives in home-manager's lib,
    # not in the NixOS one.
    users.alex = { config, ... }: {
      home.stateVersion = "26.05";

      xdg.configFile = {
        # Tuned often -- kept live. See the header.
        "sway/config".source = config.lib.file.mkOutOfStoreSymlink "${repo}/dotfiles/sway/config";

        # Stable -- immutable copies in the store.
        "sway/wallpaper.jpg".source = ../dotfiles/sway/wallpaper.jpg;
        "alacritty/alacritty.toml".source = ../dotfiles/alacritty/alacritty.toml;
        "picom/picom.conf".source = ../dotfiles/picom/picom.conf;

        # The i3 rescue session's config. Immutable on purpose: if this file
        # ever needs editing, the thing to fix is the Sway session, not this.
        "i3/config".source = ../dotfiles/i3/config;
      };
    };
  };
}
