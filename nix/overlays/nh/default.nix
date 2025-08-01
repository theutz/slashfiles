{ channels, inputs, ... }: final: prev: let
  nh = inputs.nh.packages.${prev.system}.default;
in  {
}
