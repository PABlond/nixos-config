# nixpkgs overlays.
#
# Both overlays present are WORKAROUNDS for upstream nixpkgs regressions from
# November 2026, not architectural choices. Each file documents why it exists
# and the condition for removing it -- read them before wondering why they
# are here.
#
# An overlay is preferable to a locally declared package: `pkgs.brave` and
# `pkgs.vscode` keep their normal names, so the day upstream is fixed, the
# only thing to do is drop a line here and delete the file. Nothing else in
# the configuration mentions the workaround.

{ ... }:

{
  nixpkgs.overlays = [
    (import ../overlays/brave.nix)
    (import ../overlays/vscode-ripgrep.nix)
  ];
}
