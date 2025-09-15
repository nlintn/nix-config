{ ... }:

{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    alsa.enable = false;
    jack.enable = false;
  };
  services.pulseaudio.enable = false;
}
