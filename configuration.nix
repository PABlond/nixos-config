# Point d'entrée de la configuration système de l'hôte `nixos`.
#
# Ce fichier ne contient que des imports : tout le contenu vit dans modules/.
# Pour trouver une option, cherche le module dont le nom correspond au domaine.

{ ... }:

{
  imports = [
    # Généré par nixos-generate-config — à ne pas éditer à la main.
    ./hardware-configuration.nix

    ./modules/boot.nix
    ./modules/locale.nix
    ./modules/networking.nix
    ./modules/nvidia.nix
    ./modules/desktop-gnome.nix
    ./modules/audio.nix
    ./modules/users.nix
    ./modules/shell.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/virtualisation.nix
  ];

  # Version de NixOS au moment du premier install sur cette machine.
  # Sert la compatibilité des données applicatives — ne JAMAIS la changer,
  # même après une montée de version. Voir `man configuration.nix`.
  system.stateVersion = "26.05";
}
