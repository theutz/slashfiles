{ pkgs, ... }:
let
  user = "michael";
in
{
  users.users.${user} = {
    description = "Michael Utz";
    home = "/Users/${user}";
    shell = pkgs.zsh;
    uid = 501;
  };

  snowfallorg.users.${user} = {
    create = true;
    # admin = true;
    # Don't use home-manager as a darwin module
    home.enable = false;
    home.path = "/Users/${user}";
  };

}
