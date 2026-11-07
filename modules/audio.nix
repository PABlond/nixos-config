# Audio : PipeWire, avec les couches de compatibilité ALSA et PulseAudio.
#
# `services.pulseaudio.enable = false` est obligatoire : PulseAudio et PipeWire
# ne peuvent pas cohabiter. `rtkit` donne à PipeWire la priorité temps réel,
# sans quoi on entend des coupures sous charge.

{ ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # À activer si une application JACK est nécessaire (Audacity n'en a pas
    # besoin, il passe par ALSA).
    # jack.enable = true;
  };
}
