{
  perSystem = {
    inputs',
    config,
    pkgs,
    ...
  }: {
    devShells = rec {
      default = slashfiles;
      slashfiles = pkgs.mkShellNoCC {
        name = "slashfiles";
        meta.description = ''
          The default development shell for my Nix flake.
        '';

        inputsFrom = [config.treefmt.build.devShell];

        NH_FLAKE = "/etc/nix-darwin";

        packages =
          [
            # From inputs
            inputs'.nh.packages.default

            # Packages from my config
            config.packages.swch

            # From flake-parts modules
            config.treefmt.build.wrapper # Use `treefmt` command
          ]
          ++ (with pkgs; [
            git
            lazygit
            onefetch
          ]);

        shellHook =
          /*
          bash
          */
          ''
            onefetch
          '';
      };
    };
  };
}
