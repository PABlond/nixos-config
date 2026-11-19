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
    users.alex = { config, pkgs, ... }: {
      home.stateVersion = "26.05";

      # Appearance. GNOME used to own all of this through gnome-tweaks, set by
      # hand and stored nowhere -- which is why whitesur-gtk-theme and
      # whitesur-icon-theme were in the package list while nothing applied
      # them. Declared here instead, so it survives a reinstall.
      #
      # WhiteSur is the macOS-alike suite; Dark to match the Catppuccin Mocha
      # colours in the sway config. `-Light`, and the `-solid` variants without
      # transparency, are drop-in replacements for the name below.
      gtk = {
        enable = true;

        theme = {
          name = "WhiteSur-Dark";
          package = pkgs.whitesur-gtk-theme;
        };

        iconTheme = {
          name = "WhiteSur-dark";
          package = pkgs.whitesur-icon-theme;
        };

        font = {
          name = "Noto Sans";
          size = 11;
        };
      };

      # Cursor. Nothing was installed at all before this -- not one directory
      # under share/icons had a cursors/ subdir, so what was on screen was
      # sway's built-in default.
      #
      # apple-cursor ships Apple's actual artwork and is therefore unfree;
      # allowUnfree in packages.nix covers it. `whitesur-cursors` (theme name
      # "WhiteSur-cursors") is the free lookalike if that matters.
      #
      # This sets GTK, X11/XWayland and XCURSOR_* in the session environment.
      # It does NOT configure sway: the `sway.enable` sub-option writes into
      # home-manager's wayland.windowManager.sway module, which is unused here
      # since the sway config is a plain file -- it would be silently inert.
      # The `seat * xcursor_theme` line in dotfiles/sway/config does that job.
      home.pointerCursor = {
        package = pkgs.apple-cursor;
        name = "macOS";
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };

      xdg.configFile = {
        # Tuned often -- kept live. See the header.
        "sway/config".source = config.lib.file.mkOutOfStoreSymlink "${repo}/dotfiles/sway/config";

        # Same reasoning: a bar's colours and module list get fiddled with, and
        # `killall -SIGUSR2 waybar` reloads both files with no rebuild.
        "waybar/config".source = config.lib.file.mkOutOfStoreSymlink "${repo}/dotfiles/waybar/config";
        "waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "${repo}/dotfiles/waybar/style.css";

        # Stable -- immutable copies in the store.
        #
        # The wallpaper is sourced from wallpapers/ rather than dotfiles/, so
        # that directory stays the one place images live. The target name is
        # generic AND extensionless on purpose: swapping the background is a
        # change to this single line whatever the image format, with the sway
        # config untouched. It was `wallpaper.jpg` while pointing at a .png,
        # which worked -- swaybg sniffs the content, not the name -- but lied.
        #
        # A new image here must be `git add`ed before it will build. A flake
        # only sees git-tracked files, and the error does not say so.
        #
        # wallpapers/ was orphaned when desktop-gnome.nix went away -- it was
        # the only thing referencing it, through a dconf picture-uri.
        "sway/wallpaper".source = ../wallpapers/satellite.png;
        "alacritty/alacritty.toml".source = ../dotfiles/alacritty/alacritty.toml;
        "picom/picom.conf".source = ../dotfiles/picom/picom.conf;

        # The i3 rescue session's config. Immutable on purpose: if this file
        # ever needs editing, the thing to fix is the Sway session, not this.
        "i3/config".source = ../dotfiles/i3/config;
      };
    };
  };
}
