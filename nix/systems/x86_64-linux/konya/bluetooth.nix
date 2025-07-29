{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bluetuith
    bluetui
  ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
