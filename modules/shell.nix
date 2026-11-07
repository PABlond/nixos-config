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
      rebuild = "sudo nixos-rebuild switch";
      update = "sudo nix-channel --update";
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
