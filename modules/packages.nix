# Paquets installés dans le profil système, et réglages nixpkgs.
#
# L'ordre de la liste est conservé tel quel depuis la config d'origine : le
# regroupement par thème arrive dans un commit séparé, pour que le découpage
# en modules soit vérifiable comme strictement neutre.
#
# Les extensions GNOME listées ici doivent rester cohérentes avec
# `enabled-extensions` dans desktop-gnome.nix : installer le paquet ne suffit
# pas à activer l'extension, et l'activer sans le paquet ne fait rien.

{ pkgs, ... }:

let
  # Brave : retiré de nixpkgs 26.05 le 2026-11-04 (PR #582874), faute de
  # committer parmi les mainteneurs pour relayer les correctifs de sécurité.
  # On le reprend au dépôt du mainteneur d'origine, qui pointe vers les mêmes
  # binaires précompilés que nixpkgs utilisait.
  # À RETIRER dès que `pkgs.brave` revient sur 26.05 — PR #584546.
  braveSrc = builtins.fetchTarball {
    url = "https://codeberg.org/buckley310/brave-browser-nix/archive/main.tar.gz";
    sha256 = "0i64spq93r5hixi0jkwn4z7g46c1cc8axkmb6m5av6bc35ps2inn";
  };
  bravePkgs = pkgs.callPackage "${braveSrc}/brave" { };
in

{
  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  # Permet d'exécuter des binaires non-Nix (AppImages, outils téléchargés) en
  # leur fournissant un éditeur de liens dynamique.
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
    # python312 sans sa doc : économise plusieurs centaines de Mo.
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
    bravePkgs.brave
    nmap
    rpi-imager
    tor-browser

    gnomeExtensions.blur-my-shell
    gnomeExtensions.simple-workspaces-bar
    gnomeExtensions.just-perfection
    gnomeExtensions.tiling-shell
  ];
}
