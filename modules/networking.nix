# Réseau : nom d'hôte, NetworkManager et pare-feu.
#
# Le port 5432 (PostgreSQL) n'est ouvert QUE sur l'interface tailscale0, donc
# joignable uniquement depuis le tailnet — jamais exposé au réseau local ni à
# Internet. C'est la base poker qui écoute derrière.

{ ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 5432 ];
}
