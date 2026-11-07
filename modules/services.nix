# System services: printing, Tailscale, SSH and the Caddy reverse proxy.
#
# Caddy gives readable names to locally running dev services instead of having
# to remember port numbers. The matching firewall rule is in networking.nix.

{ ... }:

{
  services.printing.enable = true;

  services.tailscale.enable = true;
  services.openssh.enable = true;

  services.caddy = {
    enable = true;

    # Poker coach -- http://pcoach.localhost
    virtualHosts."pcoach.localhost".extraConfig = ''
      reverse_proxy 127.0.0.1:8080
    '';

    # Dev front end (Vite) -- http://clipping.localhost
    virtualHosts."clipping.localhost".extraConfig = ''
      reverse_proxy 127.0.0.1:5173
    '';
  };
}
