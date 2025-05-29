{...}: {
  flake = {...}: {
    darwinModules = {
      brew = import ./brew;
    };
  };
}
