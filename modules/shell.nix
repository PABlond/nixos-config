# Interactive shell: zsh + oh-my-zsh.
#
# `programs.zsh.enable` is required for zsh to be usable as a login shell (it
# installs the /etc/zsh* files). Assigning the shell to the user happens in
# users.nix.

{ ... }:

{
  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      c = "clear";
      ":q" = "exit";
      # The flake path is absolute on purpose: these must work from any
      # working directory, including under sudo.
      rebuild = "sudo nixos-rebuild switch --flake /home/alex/dev/nixos-config#nixos";
      # Bumps flake.lock only. Review the diff, then `rebuild`; if it turns
      # out badly, `git revert` the lock commit.
      update = "nix flake update --flake /home/alex/dev/nixos-config";
    };

    ohMyZsh = {
      enable = true;
      theme = "josh";
      plugins = [
        "git"
        "sudo"
      ];
    };

    interactiveShellInit = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}
