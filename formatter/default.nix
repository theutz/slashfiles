{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];
  perSystem = {config, ...}: {
    formatter = config.treefmt.build.wrapper;
    treefmt = {
      projectRootFile = "flake.nix";
      enableDefaultExcludes = true;
      settings = {
        global.excludes = ["*.age" "*.sops*" "*.envrc"];
      };

      programs = {
        alejandra.enable = true;
        deadnix.enable = true;
        taplo.enable = true;
        shellcheck.enable = true;
        shfmt = {
          enable = true;
          indent_size = 2;
        };
      };
    };
  };
}
