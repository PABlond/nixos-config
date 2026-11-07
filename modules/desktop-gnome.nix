# Bureau GNOME : GDM, extensions et réglages dconf imposés.
#
# Les réglages passent par un profil dconf système, donc ils s'appliquent sans
# intervention et survivent à une réinitialisation du profil utilisateur.
#
# Les paquets des extensions GNOME sont déclarés dans packages.nix ; ici on ne
# fait que les activer. Les deux doivent rester cohérents.
#
# Le chemin du fond d'écran est relatif à CE fichier : wallpapers/ vit à la
# racine du dépôt, d'où le `..`.

{ lib, ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/background" = {
          picture-uri = "file://${../wallpapers/spacex2.jpg}";
          picture-uri-dark = "file://${../wallpapers/spacex2.jpg}";
          picture-options = "zoom";
        };

        "org/gnome/desktop/screensaver" = {
          picture-uri = "file://${../wallpapers/spacex2.jpg}";
        };

        # Nombre d'espaces de travail figé à 10, pour que les raccourcis
        # Alt+1..0 ci-dessous aient toujours une cible.
        "org/gnome/mutter" = {
          dynamic-workspaces = false;
        };

        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = lib.gvariant.mkInt32 10;
          focus-mode = "sloppy";
        };

        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-1 = [ "<Alt>1" ];
          switch-to-workspace-2 = [ "<Alt>2" ];
          switch-to-workspace-3 = [ "<Alt>3" ];
          switch-to-workspace-4 = [ "<Alt>4" ];
          switch-to-workspace-5 = [ "<Alt>5" ];
          switch-to-workspace-6 = [ "<Alt>6" ];
          switch-to-workspace-7 = [ "<Alt>7" ];
          switch-to-workspace-8 = [ "<Alt>8" ];
          switch-to-workspace-9 = [ "<Alt>9" ];
          switch-to-workspace-10 = [ "<Alt>0" ];

          move-to-workspace-1 = [ "<Alt><Shift>1" ];
          move-to-workspace-2 = [ "<Alt><Shift>2" ];
          move-to-workspace-3 = [ "<Alt><Shift>3" ];
          move-to-workspace-4 = [ "<Alt><Shift>4" ];
          move-to-workspace-5 = [ "<Alt><Shift>5" ];
          move-to-workspace-6 = [ "<Alt><Shift>5" ];
          move-to-workspace-7 = [ "<Alt><Shift>7" ];
          move-to-workspace-8 = [ "<Alt><Shift>8" ];
          move-to-workspace-9 = [ "<Alt><Shift>9" ];
          move-to-workspace-10 = [ "<Alt><Shift>0" ];
        };

        "org/gnome/shell" = {
          disable-user-extensions = false;

          enabled-extensions = [
            "simple-workspaces-bar@null-git"
            "just-perfection-desktop@just-perfection"
            "tilingshell@ferrarodomenico.com"
            "blur-my-shell@aunetx"
          ];
        };
      };
    }
  ];
}
