{inputs, ...}: _: prev: {
  nh = inputs.nh.packages.${prev.system}.default;
}
