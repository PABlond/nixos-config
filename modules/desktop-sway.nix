# Sway: the daily desktop. Wayland, i3-compatible, no GNOME.
#
# Why Sway and not i3 or Hyprland, so the choice is not re-litigated later:
#   - This host already ran GNOME on Wayland on an RTX 2080 with the 595
#     proprietary driver in open-module mode, so the hardware question was
#     answered empirically before switching. The Sway module here only warns
#     for NVIDIA drivers older than 551.
#   - Both monitors are 1920x1080, so nothing is lost by *not* having X11:
#     fractional scaling and mixed DPI, Wayland's main draws, do not apply.
#   - Sway speaks i3's config language, so years of muscle memory carry over.
#   - Hyprland is still 0.x and breaks its own config between releases, which
#     is the opposite of what this machine is for.
#
# Most of the session plumbing comes from `programs.sway` itself -- it already
# sets security.polkit, pam for swaylock, xwayland, dconf, the XDG portals
# (gtk for everything, wlr for screencast/screenshot) and XDG autostart, and
# it registers the Sway session with the display manager. Do not duplicate
# those here.
#
# The session's own autostart (bar, notifications, tray, idle) lives in
# ~/.config/sway/config as plain `exec` lines, deliberately: that is how it
# worked under i3, it is visible in one file, and it is editable without a
# rebuild.

{ pkgs, ... }:

{
  programs.sway = {
    enable = true;

    # Needed for GTK apps to pick up their theme and portal settings.
    wrapperFeatures.gtk = true;

    # Silences the swaynag shown at every login: "Proprietary GPU drivers are
    # not supported by sway. Do not report issues." Sway's own message names
    # this flag as the way to dismiss it (the alternative is
    # SWAY_UNSUPPORTED_GPU=true).
    #
    # It changes nothing about how sway runs -- it is an acknowledgement, and
    # upstream's point is that bug reports from this setup are unwelcome. The
    # driver here is 595, far past the 551 below which the NixOS module raises
    # a real warning, so this is cosmetic rather than a risk being papered
    # over. If sway ever does misbehave, this flag is the first thing to
    # remove before looking for help.
    extraOptions = [ "--unsupported-gpu" ];

    # Replaces the module's default list. Dropped from it: `foot` (alacritty
    # is the terminal here), `wmenu` (fuzzel below), `brightnessctl` (desktop,
    # no backlight). Kept: the lock/idle pair, grim, and pulseaudio for the
    # `pactl` the volume keys call.
    extraPackages = with pkgs; [
      swaylock
      swayidle
      grim
      pulseaudio
    ];
  };

  # SDDM rather than GDM (which is GNOME) or greetd. greetd does not start an
  # X server, and the i3 fallback has to work on precisely the day Sway does
  # not -- SDDM lists X11 and Wayland sessions natively. Its greeter stays on
  # X11 (sddm.wayland.enable defaults to false), which is the better-trodden
  # path with the NVIDIA driver.
  services.displayManager.sddm.enable = true;

  # Chromium, Brave, VS Code and other Electron apps run natively on Wayland
  # instead of through XWayland. Harmless in the i3/X11 session: the hint
  # falls back to X11 when there is no Wayland display.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # GNOME used to provide this. VS Code and Brave store their secrets in it,
  # so without it they start asking for passwords again.
  services.gnome.gnome-keyring.enable = true;

  # Also previously implied by GNOME: mounting a USB stick from the tray.
  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    # Launcher, bound to $mod+d. dmenu's ergonomics, native Wayland.
    fuzzel

    # Bar, notifications, wallpaper, lock -- the pieces GNOME Shell used to be.
    waybar
    mako
    swaybg

    # Screenshots. GNOME's Print-key overlay is part of gnome-shell and cannot
    # be carried over; grim+slurp is the Wayland equivalent (select a region,
    # straight to the clipboard). flameshot is X11-oriented and degrades badly
    # here, which is why it is not used.
    slurp
    wl-clipboard

    # Tray residents, started from the sway config
    networkmanagerapplet # nm-applet --indicator
    lxqt.lxqt-policykit # authorisation prompts; nothing provides them otherwise
    udiskie # automount + tray

    # Display layout, for when the DP-2 / HDMI-A-1 arrangement needs changing
    wdisplays

    # Qt apps (VirtualBox, pavucontrol is GTK but VirtualBox is Qt) need this
    # to run as Wayland clients rather than falling back to XWayland.
    qt6.qtwayland

    # Kept from GNOME on request.
    gnome-calculator
  ];
}
