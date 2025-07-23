{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kitty
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
  };
}
