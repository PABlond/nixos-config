# NVIDIA RTX 2080 (Turing) -- proprietary driver.
#
# `open = true` uses NVIDIA's open-source kernel modules, supported from
# Turing onwards. `enable32Bit` is required by Wine/Proton (Lutris).

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

  # Exposes the GPU to Docker containers.
  hardware.nvidia-container-toolkit.enable = true;

  # Creates /dev/nvidia* at boot. Without it, CUDA workloads started outside a
  # graphical session fail for lack of device nodes.
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
