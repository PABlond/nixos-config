# TEMPORARY WORKAROUND -- VS Code 1.144.0 fails to build on 26.05.
#
# Upstream bug: https://github.com/NixOS/nixpkgs/issues/584492
#
# nixpkgs replaces the ripgrep bundled in VS Code with its own, at a path
# hardcoded in pkgs/applications/editors/vscode/generic.nix:
#
#   rm resources/app/node_modules/@vscode/ripgrep/bin/rg
#   ln -s ${ripgrep}/bin/rg resources/app/node_modules/@vscode/ripgrep/bin/rg
#
# Since 1.144.0, upstream moved that binary to
# node_modules.asar.unpacked/@vscode/ripgrep-universal/bin/linux-x64/rg, so
# the `rm` hits a nonexistent file and the build stops:
#
#   rm: cannot remove '.../@vscode/ripgrep/bin/rg': No such file or directory
#
# The `useVSCodeRipgrep` parameter does not help: its `else` branch runs
# `chmod +x` on the very same nonexistent path.
#
# So we rewrite only the path inside the already-generated postPatch, which
# preserves everything else (jschardet symlink, patchelf, wrappers).
#
# REMOVE once the fix reaches 26.05. If upstream fixes it by changing this
# path, replaceStrings will match nothing and the overlay becomes silently
# inert -- it will not break the rebuild, but there is no point keeping a
# ghost workaround around.

final: prev: {
  vscode = prev.vscode.overrideAttrs (old: {
    postPatch = builtins.replaceStrings
      [ "resources/app/node_modules/@vscode/ripgrep/bin/rg" ]
      [ "resources/app/node_modules.asar.unpacked/@vscode/ripgrep-universal/bin/linux-x64/rg" ]
      old.postPatch;
  });
}
