# System services: printing, Tailscale and SSH.

{ ... }:

{
  services.printing.enable = true;

  services.tailscale.enable = true;
  services.openssh.enable = true;
}
