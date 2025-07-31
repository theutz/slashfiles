{
  pkgs,
  lib,
  config,
  ...
}: {
  users = {
    users.michael = {
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

    groups.michael = {};
  };

  programs.zsh.enable = lib.mkForce true; # required to set default shell to zsh
}
