# nixpkgs overlays.
#
# The overlay present is a WORKAROUND for an upstream nixpkgs regression from
# November 2026, not an architectural choice. The file documents why it exists
# and the condition for removing it -- read it before wondering why it is
# here.
#
# An overlay is preferable to a locally declared package: `pkgs.brave` keeps
# its normal name, so the day upstream is fixed, the only thing to do is drop
# a line here and delete the file. Nothing else in the configuration mentions
# the workaround.
#
# vscode-ripgrep.nix was removed on 2026-11-19. It patched a path that VS Code
# 1.144.0 had moved; upstream resolved the bug by reverting to 1.119.0, which
# restored the original path. The overlay then rewrote a correct path into a
# nonexistent one and broke the build -- the opposite of the "silently inert"
# outcome its own header predicted. Reverting a version, not fixing a path,
# is the case that header missed.

{ ... }:

{
  nixpkgs.overlays = [
    (import ../overlays/brave.nix)
  ];
}
