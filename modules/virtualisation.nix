# Virtualisation: VirtualBox, Docker and libvirt/QEMU.
#
# All three coexist, but do not run a VirtualBox VM and a KVM VM at the same
# time: they compete for the hardware virtualisation extensions and the second
# one will refuse to start.
#
# Membership of the `vboxusers`, `docker` and `libvirtd` groups is declared in
# users.nix.

{ pkgs, ... }:

{
  # Builds the VirtualBox kernel module.
  virtualisation.virtualbox.host.enable = true;
  # Extension pack: USB 2.0/3.0 passthrough for guests.
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.host.enableHardening = false;

  virtualisation.docker.enable = true;

  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      # Emulated TPM 2.0 -- required by Windows 11 guests.
      swtpm.enable = true;
    };
  };
}
