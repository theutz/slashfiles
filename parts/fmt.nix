{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem = {config, ...}: {
    formatter = config.treefmt.build.wrapper;
    treefmt = {
      projectRootFile = "flake.nix";
      enableDefaultExcludes = true;

      programs = {
        alejandra.enable = true;
        shellcheck.enable = true;

        shfmt.enable = true;
        shfmt.indent_size = 2;
      };
    };
  };
}
