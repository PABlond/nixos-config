{
  description = "NixOS configuration for host nixos";

  # nixpkgs is tracked on the 26.05 release branch, but the exact revision is
  # pinned in flake.lock. The branch name here only says *where* updates come
  # from; it never changes the system on its own.
  #
  # To move to a newer nixpkgs, deliberately:
  #   nix flake update
  # and if it turns out to break something:
  #   git revert <the flake.lock commit>
  #
  # That last point is the whole reason this repo uses a flake. With channels,
  # `nix-channel --update` silently took whatever upstream had published --
  # which is how the brave removal and the vscode 1.144.0 breakage landed here
  # unannounced in November 2026.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
