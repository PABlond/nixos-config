# Virtualisation : VirtualBox, Docker et libvirt/QEMU.
#
# Les trois cohabitent, mais ne fais pas tourner une VM VirtualBox et une VM
# KVM en même temps : elles se disputent les extensions de virtualisation
# matérielle et la seconde refusera de démarrer.
#
# L'appartenance aux groupes `vboxusers`, `docker` et `libvirtd` est déclarée
# dans users.nix.

{ pkgs, ... }:

{
  # Compile le module noyau VirtualBox.
  virtualisation.virtualbox.host.enable = true;
  # Pack d'extension : support USB 2.0/3.0 dans les invités.
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.host.enableHardening = false;

  virtualisation.docker.enable = true;

  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      # TPM 2.0 émulé — exigé par Windows 11 en invité.
      swtpm.enable = true;
    };
  };
}
