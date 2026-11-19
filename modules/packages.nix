# Packages installed into the system profile, plus nixpkgs settings.
#
# Grouped by purpose. Desktop-specific tooling does not live here: the Sway
# session's pieces are in desktop-sway.nix and the i3 rescue session's in
# desktop-i3.nix, each next to the option that enables them.

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
    inkscape
    gimp

    # Audio control
    pavucontrol
    alsa-utils

    # Keyring management. Needed when an app prompts to unlock the keyring:
    # that means the keyring's own password has diverged from the login
    # password, so PAM's automatic unlock cannot succeed. Open the "Login"
    # keyring here and set its password to the login one -- or to empty, which
    # removes the prompt at the cost of encryption at rest.
    seahorse

    # Office
    libreoffice

    # Desktop, theming and launcher
    # albert is kept, but Sway binds fuzzel to $mod+d: albert registers its
    # global hotkey through X11, so under Wayland it has to be triggered from
    # the compositor anyway (`albert toggle`).
    albert

    # The macOS-alike theme suite. Also declared in modules/home.nix, which is
    # what actually applies them; kept here so SDDM and XWayland clients find
    # them outside the user profile too.
    whitesur-icon-theme
    whitesur-gtk-theme
    apple-cursor

    # Gaming
    lutris

    # Network
    tailscale

    # Misc
    qbittorrent
    rpi-imager
  ];
}
