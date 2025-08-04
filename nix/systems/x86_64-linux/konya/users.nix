{
  pkgs,
  lib,
  ...
}: {
  users.users.michael = {
    isNormalUser = true;
    createHome = true;
    group = "michael";
    extraGroups = ["networkmanager" "wheel"];
    # packages = with pkgs; [
    #   sops
    #   ssh-to-age
    # ];
    shell = pkgs.zsh;
  };
  users.groups.michael = {};

  # Explicitly don't integrate Home Manager, so that
  # we can manage as standalone with `nh home switch`
  snowfallorg.users.michael.home.enable = false;
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "bak";

  programs.zsh.enable = lib.mkForce true; # required to set default shell to zsh
}
