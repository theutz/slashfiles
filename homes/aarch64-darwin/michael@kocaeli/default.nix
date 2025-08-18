{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) genEnabledMods;
in
{
  # ${namespace} = (genEnabledMods (import ./mods.nix));

  # home = {
  #   sessionPath = [
  #     osConfig.homebrew.brewPrefix
  #   ];
  #
  #   shell = {
  #     # Enables in all shells
  #     enableShellIntegration = true;
  #   };
  # };
  #
  # programs = {
  #   home-manager = {
  #     enable = true;
  #   };
  # };

  sops.age.keyFile = config.xdg.configHome + "/sops/age/keys.txt";

  home.stateVersion = "25.05";
}
