{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alsa-lib
  ];

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };
  services.pulseaudio.enable = false;

  # Helps audio glitching by enabling realtime priority
  security.rtkit.enable = true;

  users.users.michael.extraGroups = [ "audio" ];
}
