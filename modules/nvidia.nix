# GPU NVIDIA RTX 2080 (Turing) — pilote propriétaire.
#
# `open = true` utilise les modules noyau open-source de NVIDIA, pris en charge
# à partir de Turing. `enable32Bit` est nécessaire pour Wine/Proton (Lutris).

{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
  };

  # Expose le GPU aux conteneurs Docker.
  hardware.nvidia-container-toolkit.enable = true;

  # Crée /dev/nvidia* au démarrage : sans ça, les charges CUDA lancées hors
  # session graphique échouent faute de nœuds de périphérique.
  systemd.services.nvidia-device-nodes = {
    description = "Create NVIDIA device nodes";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];

    serviceConfig.Type = "oneshot";

    script = ''
      ${pkgs.nvidia-modprobe}/bin/nvidia-modprobe -u -c=0
    '';
  };
}
