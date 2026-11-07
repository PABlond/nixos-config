

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, lib, ... }:

let
  # Brave : retiré de nixpkgs 26.05 le 2026-11-04, retour en attente (PR #584546).
  # Dépôt du mainteneur nixpkgs de brave. À retirer dès que `pkgs.brave` revient.
  braveSrc = builtins.fetchTarball {
    url = "https://codeberg.org/buckley310/brave-browser-nix/archive/main.tar.gz";
    sha256 = "0i64spq93r5hixi0jkwn4z7g46c1cc8axkmb6m5av6bc35ps2inn";
  };
  bravePkgs = pkgs.callPackage "${braveSrc}/brave" { };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
    options = "caps:escape";
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia-container-toolkit.enable = true;

  hardware.nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
    };

    systemd.services.nvidia-device-nodes = {
    description = "Create NVIDIA device nodes";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];

    serviceConfig.Type = "oneshot";

    script = ''
      ${pkgs.nvidia-modprobe}/bin/nvidia-modprobe -u -c=0
    '';
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."alex" = {
    isNormalUser = true;
    description = "alex";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "vboxusers" "docker" "libvirtd" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      c = "clear";
      ":q" = "exit";
      rebuild = "sudo nixos-rebuild switch";
      update = "sudo nix-channel --update";
    };
    

    ohMyZsh = {
      enable = true;
      theme = "josh";
      plugins = [
        "git"
        "sudo"
      ];
    };

    interactiveShellInit = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/background" = {
          picture-uri = "file://${./wallpapers/spacex2.jpg}";
          picture-uri-dark = "file://${./wallpapers/spacex2.jpg}";
          picture-options = "zoom";
        };

        "org/gnome/desktop/screensaver" = {
          picture-uri = "file://${./wallpapers/spacex2.jpg}";
        };

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    htop
    alacritty
    vscode
    # davinci-resolve
    claude-code
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
    #brave   
    bravePkgs.brave
    nmap
    rpi-imager
    tor-browser
 
    # qgroundcontrol

    gnomeExtensions.blur-my-shell
    gnomeExtensions.simple-workspaces-bar
    gnomeExtensions.just-perfection
    gnomeExtensions.tiling-shell
  ];

services.tailscale.enable = true;
services.openssh.enable = true;


services.caddy = {
  enable = true;
  virtualHosts."pcoach.localhost".extraConfig = ''
    reverse_proxy 127.0.0.1:8080
  '';
  virtualHosts."clipping.localhost".extraConfig = ''
    reverse_proxy 127.0.0.1:5173
  '';
};

# Active l'extension VirtualBox et compile le module noyau
virtualisation.virtualbox.host.enable = true;
virtualisation.virtualbox.host.enableExtensionPack = true; # (Optionnel) pour le support USB 2.0/3.0
virtualisation.virtualbox.host.enableHardening = false;

virtualisation.docker.enable = true;

programs.virt-manager.enable = true;

virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true; # Emulation TPM 2.0 pour Windows 11
    };
  };
  

# Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # Use the WirePlumber session manager
    #wireplumber.enable = true;
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 5432 ];
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
