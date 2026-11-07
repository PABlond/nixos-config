# Shell interactif : zsh + oh-my-zsh.
#
# `programs.zsh.enable` est requis pour que zsh soit utilisable comme shell de
# connexion (il installe les fichiers /etc/zsh*). Le choix du shell pour
# l'utilisateur se fait dans users.nix.

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
