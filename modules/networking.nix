# Networking: hostname, NetworkManager and firewall.
#
# Port 5432 (PostgreSQL) is opened ONLY on the tailscale0 interface, so it is
# reachable from the tailnet and never exposed to the LAN or the internet.
# The poker database listens behind it.

{ ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 5432 ];
}
