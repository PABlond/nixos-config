# Fonts.
#
# This module exists because there were none declared at all. GNOME used to
# pull a usable set in as a dependency; removing it left the system with no
# icon font and no emoji font, which is why waybar's bar came up full of
# boxes -- its default config is written in Font Awesome glyphs.
#
# `fc-list | grep -ciE 'awesome|nerd|symbols'` returned 0 before this.

{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      # The icon font waybar's default config actually targets. Without it the
      # bar renders tofu, and no amount of waybar styling fixes that.
      font-awesome

      # Nerd Fonts: icon coverage plus a real monospace face, so terminal
      # prompts and editor statuslines that use glyphs work too. Hack is the
      # one in use (see defaultFonts below); JetBrainsMono stays as a fallback
      # and an easy swap.
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono

      # Broad Unicode coverage and colour emoji. Without these, anything
      # outside Latin renders as boxes -- including emoji in a browser.
      noto-fonts
      noto-fonts-color-emoji
    ];

    # Pick deliberately rather than letting fontconfig guess from whatever
    # happens to be installed first.
    #
    # This is the single lever for the terminal font: alacritty.toml asks for
    # the generic family `monospace`, so it resolves through here. Nothing in
    # the dotfiles hardcodes a family -- change the first entry and the
    # terminal, swaynag and every other monospace consumer follow.
    #
    # The `Mono` variant on purpose: Nerd Fonts ship three families per font,
    # and only `... Nerd Font Mono` keeps every glyph to exactly one cell.
    # Plain `Hack Nerd Font` lets icons take two, which looks better in
    # isolation but misaligns columns in TUIs.
    fontconfig.defaultFonts = {
      monospace = [
        "Hack Nerd Font Mono"
        "JetBrainsMono Nerd Font"
      ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
