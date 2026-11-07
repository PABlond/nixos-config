# Boot: loader and foreign-architecture emulation.
#
# The ESP is /dev/nvme0n1p1 (1 GB) mounted at /boot, and it is SHARED with the
# Windows loader (\EFI\Microsoft\Boot\bootmgfw.efi). systemd-boot discovers
# that on its own and shows a Windows entry -- nothing to declare for it.
#
# To reboot straight into Windows without touching the menu:
#   sudo systemctl reboot --boot-loader-entry=auto-windows

{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Allows building and running aarch64 binaries (Raspberry Pi).
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
