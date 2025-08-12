{
  pkgs,
  lib,
  inputs,
  ...
}:
(inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;

  extraSpecialArgs = { };

  modules =
    with lib.fileset;
    [ ./default.nix ] # Exceptions
    |> unions
    |> difference ./.
    |> toList;
}).neovim
