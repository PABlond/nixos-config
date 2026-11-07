# User accounts.
#
# The groups grant passwordless access to NetworkManager, VirtualBox, Docker
# and libvirt. `wheel` grants sudo. No password is declared here (set it with
# `passwd`) -- this repository holds no secrets.
#
# The zsh configuration itself lives in shell.nix.

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
