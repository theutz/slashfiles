{
  pkgs,
  lib,
  inputs,
  namespace,
  ...
}:
(inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;

  extraSpecialArgs = {
    inherit namespace;
    lib' = lib.${namespace};
    nil_ls = inputs.nil_ls.outputs.packages.${pkgs.system}.nil;
  };

  modules =
    with lib.fileset;
    [ ./default.nix ] # Exceptions
    |> unions
    |> difference ./.
    |> toList;
}).neovim
