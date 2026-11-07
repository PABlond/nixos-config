# Services système : impression, Tailscale, SSH et reverse proxy Caddy.
#
# Caddy donne des noms lisibles aux services de dev tournant en local, plutôt
# que de retenir des numéros de port. L'ouverture du pare-feu correspondante
# est dans networking.nix.

{ ... }:

{
  services.printing.enable = true;

  services.tailscale.enable = true;
  services.openssh.enable = true;

  services.caddy = {
    enable = true;

    # Coach poker — http://pcoach.localhost
    virtualHosts."pcoach.localhost".extraConfig = ''
      reverse_proxy 127.0.0.1:8080
    '';

    # Front de dev (Vite) — http://clipping.localhost
    virtualHosts."clipping.localhost".extraConfig = ''
      reverse_proxy 127.0.0.1:5173
    '';
  };
}
