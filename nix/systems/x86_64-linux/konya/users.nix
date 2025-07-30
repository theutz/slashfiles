{
  pkgs,
  lib,
  ...
}: {
  users = {
    users.michael = {
      isNormalUser = true;
      createHome = true;
      group = "michael";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [];
      shell = pkgs.zsh;
    };

    groups.michael = {};
  };

  programs.zsh.enable = lib.mkForce true; # required to set default shell to zsh
}
