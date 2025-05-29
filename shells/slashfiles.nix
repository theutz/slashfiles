{self, ...}: {
  perSystem = {
    inputs',
    config,
    pkgs,
    lib,
    ...
  }: {
    devShells.slashfiles = let
      name = "slashfiles";
      description = "/slashfiles: .dotfiles{everywhere}.nix";

      longDescription = ''
        The default development shell for my Nix flake.
      '';
    in
      pkgs.mkShellNoCC {
        inherit name;

        meta = {inherit description longDescription;};

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
            watchexec
            mask
            gum
          ]);

        shellHook =
          /*
          bash
          */
          ''
              alias m="mask"

              onefetch
              cat <<-markdown | gum format
            # ${description}

            ${longDescription}
            markdown
          '';
      };
  };
}
