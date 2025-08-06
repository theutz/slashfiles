{ inputs, ... }:
_: prev: {
  inherit (inputs.nh.packages.${prev.system}) nh;
}
