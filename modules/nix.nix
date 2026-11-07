# Nix daemon settings.
#
# Flakes must be enabled system-wide for `nixos-rebuild --flake` to work
# without passing --extra-experimental-features on every invocation.

{ ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Hard-link identical files in the store. Runs in the background and is the
  # cheapest way to keep /nix/store from growing out of hand.
  nix.settings.auto-optimise-store = true;
}
