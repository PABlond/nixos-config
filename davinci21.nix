{ pkgs }:

pkgs.buildFHSEnv {
  name = "davinci-resolve-21";
  
  targetPkgs = pkgs: (with pkgs; [
    # Core & POSIX / Compatibility
    glibc
    libxcrypt-legacy     # <--- Fournit libcrypt.so.1
    gcc-unwrapped.lib
    zlib
    openssl
    udev
    dbus
    expat
    nss
    nspr
    cups
    util-linux
    numactl
    libxml2
    libxslt
    icu

    # GUI, Display & Input
    libxkbcommon
    xorg.libX11
    xorg.libXext
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXi
    xorg.libXxf86vm
    xorg.libxcb
    xorg.libXrender
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXtst
    xorg.libSM
    xorg.libICE
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    
    # Graphics & Hardware Acceleration
    libGL
    libGLU
    libvdpau
    libdrm
    mesa
    ocl-icd
    opencl-headers

    # Fonts & Rendering
    freetype
    fontconfig
    pango
    cairo
    gdk-pixbuf
    glib
    gtk3
    
    # Audio & Multimedia
    alsa-lib
    pulseaudio
    libsndfile
    ffmpeg
    
    # Database & System Utils
    aprutil
    sqlite
  ]);

  runScript = "/home/alex/Downloads/squashfs-root/bin/resolve";

  extraInstallPhase = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/128x128/apps
    
    cp /home/alex/Downloads/squashfs-root/DV_Resolve.png $out/share/icons/hicolor/128x128/apps/davinci-resolve-21.png

    cat <<EOF > $out/share/applications/davinci-resolve-21.desktop
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=DaVinci Resolve 21
    GenericName=Video Editor
    Comment=Professional Video Editing
    Exec=$out/bin/davinci-resolve-21
    Icon=davinci-resolve-21
    Terminal=false
    MimeType=application/x-studio-project;
    Categories=AudioVideo;Video;AudioVideoEditing;
    EOF
  '';
}
