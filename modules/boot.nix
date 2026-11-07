# Démarrage : chargeur et émulation d'architectures.
#
# L'ESP est /dev/nvme0n1p1 (1 Go), monté sur /boot, et il est PARTAGÉ avec le
# chargeur Windows (\EFI\Microsoft\Boot\bootmgfw.efi). systemd-boot le détecte
# tout seul et affiche une entrée Windows — ne rien déclarer pour ça.
#
# Pour redémarrer directement sous Windows sans passer par le menu :
#   sudo systemctl reboot --boot-loader-entry=auto-windows

{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Permet de construire et d'exécuter des binaires aarch64 (Raspberry Pi).
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
