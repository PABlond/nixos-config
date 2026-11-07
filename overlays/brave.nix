# TEMPORARY WORKAROUND -- Brave is missing from nixpkgs 26.05.
#
# Brave was dropped from nixpkgs on 2026-11-04 (PR #582838 on unstable,
# PR #582874 backported to release-26.05). Reason: none of the package's
# maintainers held commit rights, which delayed shipping security fixes --
# unacceptable for a browser.
#
# The package has since been re-added on master (PR #584534). The backport to
# 26.05 is PR #584546, still open.
#
# In the meantime we take the package from buckley310's repository -- they
# maintained nixpkgs' `brave`. It points at the same prebuilt binaries Brave
# publishes. Its layout is deliberately callPackage-compatible, so it works
# without flakes.
#
#   https://codeberg.org/buckley310/brave-browser-nix
#
# REMOVE once PR #584546 is merged and the channel has caught up. Check with:
#   nix-env -qaP 'brave' | grep -w brave
#
# Note: the sha256 PINS the version. When upstream publishes a new Brave, the
# rebuild will fail on a hash mismatch -- that is not a bug, it is the signal
# to bump it with:
#   nix-prefetch-url --unpack <url>
# This tradeoff is deliberate: a pinned hash beats a silent, non-reproducible
# download for a package sourced outside nixpkgs.

let
  src = builtins.fetchTarball {
    url = "https://codeberg.org/buckley310/brave-browser-nix/archive/main.tar.gz";
    sha256 = "0i64spq93r5hixi0jkwn4z7g46c1cc8axkmb6m5av6bc35ps2inn";
  };
in

final: prev: {
  inherit (prev.callPackage "${src}/brave" { }) brave brave-origin;
}
