# GNOME desktop: GDM, extensions and enforced dconf settings.
#
# Settings go through a system dconf profile, so they apply with no user
# action and survive a reset of the user profile.
#
# GNOME extension packages are declared in packages.nix; this file only
# enables them. The two lists must stay in sync: installing the package does
# not enable the extension, and enabling one without its package does nothing.
#
# The wallpaper path is relative to THIS file -- wallpapers/ lives at the repo
# root, hence the `..`.

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

        # Workspace count pinned to 10 so the Alt+1..0 bindings below always
        # have a target.
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
          move-to-workspace-6 = [ "<Alt><Shift>6" ];
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
