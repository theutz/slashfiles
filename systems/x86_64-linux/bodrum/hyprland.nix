{
  pkgs,
  lib,
  ...
}:
{
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM = true;
  programs.hyprland.xwayland.enable = true;
  security.pam.services.hyprlock = { };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    kitty
    wezterm
  ];
  programs.regreet.enable = true;
  services.greetd.enable = true;
  services.greetd.settings.default_session.command = ''
    ${pkgs.hyprland}/bin/Hyprland --config /etc/greetd/hyprland.conf;
  '';
  environment.etc."greetd/hyprland.conf".text = ''
    exec-once = ${lib.getExe pkgs.greetd.regreet}; ${pkgs.hyprland}/bin/hyprctl dispatch exit
    misc {
      disable_hyrpland_logo = true
      disable_splash_rendering = true
      disable_hyprland_qtutils_check = true
    }
  '';
}
