{
  namespace,
  lib,
  ...
}:
{
  imports =
    with lib.fileset;
    [
      ./default.nix
      ./mods.nix
    ]
    |> unions
    |> difference ./.
    |> toList;

  ${namespace} = lib.${namespace}.genEnabledMods (import ./mods.nix);

  system.primaryUser = lib.${namespace}.primaryUser;
  system.stateVersion = 5;
}
