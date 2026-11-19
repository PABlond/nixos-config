# i3 on X11, kept as a rescue session -- not the daily desktop.
#
# Sway is what this host actually runs (see desktop-sway.nix). This module
# exists so that a broken Wayland session, an NVIDIA driver update gone wrong
# or an XWayland regression leaves a graphical way back in that is not GNOME.
# SDDM lists it next to Sway at login.
#
# That is the whole design intent: if you find yourself tuning this file,
# either the problem belongs in desktop-sway.nix, or the decision to run Sway
# needs revisiting on purpose rather than by drift.
#
# i3's config stays at ~/.config/i3/config, unmanaged by Nix, so Mod+Shift+C
# reloads it without a rebuild. The packages here are what that file's `exec`
# lines and bindings shell out to -- on Arch they happened to be present
# system-wide; on NixOS a missing one fails silently and the binding simply
# does nothing.

{ pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.windowManager.i3 = {
    enable = true;

    # Gaps are built into i3 since 4.22 (26.05 ships 4.24), so `gaps inner`
    # and `smart_gaps on` work with plain i3. The old i3-gaps fork is gone
    # from nixpkgs and is not needed.
    extraPackages = with pkgs; [
      dmenu # $mod+d -> dmenu_run
      i3status # target of the config's `killall -SIGUSR1 i3status`
      i3lock # the locker xss-lock calls
    ];
  };

  environment.systemPackages = with pkgs; [
    # Called from the i3 config's `exec` lines
    xss-lock # lock on suspend
    xfce4-panel # used as the bar; the `bar { }` block is commented out
    feh # feh --bg-scale for the wallpaper
    picom # compositor, reads ~/.config/picom/picom.conf
    xset # xset s off -dpms

    # Notifications: mako is Wayland-only, so the X11 session needs its own
    # daemon or notifications vanish silently.
    dunst

    # Screenshots in this session. grim is Wayland-only, hence a separate tool
    # here rather than reusing the Sway binding.
    maim
    xclip

    # The i3 config pins workspaces to DP-2 and HDMI-0 (the X11/NVIDIA names
    # for what the kernel calls DP-2 and HDMI-A-1); these inspect and fix that.
    xrandr
    arandr
  ];

  # xfce4-panel keeps its layout in xfconf. Without this daemon the panel
  # starts empty and forgets anything you add to it.
  programs.xfconf.enable = true;

  # lxqt-policykit (declared in desktop-sway.nix, installed system-wide) is
  # the agent; it needs starting, which a bare WM session does not do on its
  # own. graphical-session.target is reached even for bare WMs -- the display
  # manager wrapper binds a `nixos-fake-graphical-session.target` to it for
  # exactly this case.
  systemd.user.services.lxqt-policykit-agent = {
    description = "lxqt-policykit authentication agent";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
      Restart = "on-failure";
    };
  };
}
