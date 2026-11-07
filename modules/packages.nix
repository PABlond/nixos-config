# Packages installed into the system profile, plus nixpkgs settings.
#
# Grouped by purpose. The GNOME extensions at the bottom must stay in sync
# with `enabled-extensions` in desktop-gnome.nix: installing the package is
# not enough to enable the extension, and enabling one without its package is
# a no-op.

{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  # Lets non-Nix binaries (AppImages, downloaded tools) run by providing them
  # a dynamic loader.
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    # Core shell tooling
    vim
    wget
    curl
    git
    htop
    killall
    zip
    unzip
    fuse
    nmap

    # Terminal and editors
    alacritty
    vscode
    claude-code

    # Development toolchain
    # python312 without its docs: saves several hundred MB.
    (builtins.removeAttrs python312 [ "doc" ])
    uv
    gnumake
    gcc

    # Containers
    docker
    docker-compose

    # Browsers -- firefox comes from programs.firefox above.
    # brave is provided by overlays/brave.nix until nixpkgs 26.05 ships it
    # again.
    brave
    tor-browser

    # Media and creative
    ffmpeg
    vlc
    yt-dlp
    sox
    audacity
    davinci-resolve
    inkscape
    gimp

    # Audio control
    pavucontrol
    alsa-utils

    # Office
    libreoffice

    # Desktop, theming and launcher
    albert
    gnome-tweaks
    whitesur-icon-theme
    whitesur-gtk-theme

    # Gaming
    lutris

    # Network
    tailscale

    # Misc
    qbittorrent
    rpi-imager

    # GNOME extensions -- keep in sync with desktop-gnome.nix
    gnomeExtensions.blur-my-shell
    gnomeExtensions.simple-workspaces-bar
    gnomeExtensions.just-perfection
    gnomeExtensions.tiling-shell
  ];
}
