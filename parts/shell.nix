{
  perSystem = {
    inputs',
    config,
    pkgs,
    system,
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      name = "slashfiles";
      meta.description = ''
        The default development shell for my Nix flake.
      '';

      inputsFrom = [config.treefmt.build.devShell];

      NH_DARWIN_FLAKE = "/etc/nix-darwin";

      packages =
        [
          # From inputs
          inputs'.nh.default

          # From flake-parts modules
          config.treefmt.build.wrapper # Use `treefmt` command
        ]
        ++ (with pkgs; [
          git
          lazygit
          nh
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
}
