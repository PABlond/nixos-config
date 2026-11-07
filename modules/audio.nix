# Audio: PipeWire, with ALSA and PulseAudio compatibility layers.
#
# `services.pulseaudio.enable = false` is mandatory: PulseAudio and PipeWire
# cannot coexist. `rtkit` grants PipeWire realtime priority -- without it you
# get dropouts under load.

{ ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # Enable if a JACK application is needed (Audacity does not need it, it
    # goes through ALSA).
    # jack.enable = true;
  };
}
