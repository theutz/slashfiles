_: {
  perSystem = {
    inputs',
    self',
    config,
    pkgs,
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

        buildInputs = self'.checks.pre-commit.enabledPackages;

        DIRENV_LOG_FORMAT = "";
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
            aichat
          ]);

        shellHook =
          /*
          bash
          */
          ''
            ${self'.checks.pre-commit.shellHook}
            onefetch

            cat <<-markdown | gum format
            # ${description}

            ${longDescription}
            markdown

            mask --help
          '';
      };
  };
}
