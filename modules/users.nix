# Comptes utilisateurs.
#
# Les groupes donnent accès sans sudo à : NetworkManager, VirtualBox, Docker
# et libvirt. `wheel` autorise sudo. Le mot de passe n'est pas déclaré ici
# (il se définit avec `passwd`) — aucun secret dans ce dépôt.
#
# La configuration de zsh elle-même est dans shell.nix.

{ pkgs, ... }:

{
  users.users."alex" = {
    isNormalUser = true;
    description = "alex";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "vboxusers" "docker" "libvirtd" ];
    packages = with pkgs; [
    ];
  };
}
