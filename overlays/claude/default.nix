{inputs, ...}: _: prev: {
  inherit (inputs.unstable.${prev.system}) claude-code;
}
