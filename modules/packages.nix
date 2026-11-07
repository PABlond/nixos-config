# Packages installed into the system profile, plus nixpkgs settings.
#
# The list order is kept exactly as it was in the original configuration:
# regrouping it by theme lands in a separate commit, so that the split into
# modules can be verified as strictly behaviour-neutral.
#
# The GNOME extensions listed here must stay in sync with
# `enabled-extensions` in desktop-gnome.nix: installing the package is not
# enough to enable the extension, and enabling one without its package is a
# no-op.

{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  # Lets non-Nix binaries (AppImages, downloaded tools) run by providing them
  # a dynamic loader.
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    htop
    alacritty
    vscode
    claude-code
    # python312 without its docs: saves several hundred MB.
    (builtins.removeAttrs python312 [ "doc" ])
    uv
    gnumake
    ffmpeg
    vlc
    gcc
    lutris
    pavucontrol
    tailscale
    inkscape
    gimp
    albert
    zip
    unzip
    fuse
    killall
    davinci-resolve
    pavucontrol
    yt-dlp
    whitesur-icon-theme
    whitesur-gtk-theme
    gnome-tweaks
    sox
    libreoffice
    docker
    docker-compose
    alsa-utils
    audacity
    qbittorrent
    # Provided by overlays/brave.nix until nixpkgs 26.05 ships it again.
    brave
    nmap
    rpi-imager
    tor-browser

    gnomeExtensions.blur-my-shell
    gnomeExtensions.simple-workspaces-bar
    gnomeExtensions.just-perfection
    gnomeExtensions.tiling-shell
  ];
}
