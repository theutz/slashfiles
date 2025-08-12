{ inputs, ... }:
_: prev: {
  inherit (inputs.nil_ls.outputs.packages.${prev.system}) nil;
}
