_: {
  perSystem = {
    inputs',
    config,
    pkgs,
    ...
  }: let
    prepare-commit-msg =
      pkgs.writeShellScript "prepare-commit-msg"
      # bash
      ''
        commit_msg_file="$1"
        orig="$(cat "$commit_msg_file")"

        prompt="$(cat <<-EOF
        Ignore all previous instructions.
        Write a conventional commit message for these changes.
        Remove any leading or trailing whitespace.
        Do not wrap the message in backticks.
        EOF
        )"

        generated="$(
          gum spin --show-output --title "Generating commit message..." -- \
            git diff --cached |
              aichat "$prompt"
        )"

        echo "$generated\n$orig" > "$commit_msg_file"
      '';

    installCommitMsgHook =
      # bash
      ''
        git_dir="$(git rev-parse --path-format=absolute --git-common-dir)"
        hooks_dir="''${git_dir}/hooks"
        hook="''${hooks_dir}/prepare-commit-msg"

        if [[ ! -x "$hook" ]]; then
          cp "${prepare-commit-msg}" "$hook"
          chmod +x "$hook"
        fi
      '';
  in {
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

        DIRENV_LOG_FORMAT = "";
        NH_FLAKE = "/etc/nix-darwin";

        inputsFrom = [
          config.treefmt.build.devShell
          config.packages.nvf
        ];

        packages =
          [
            # From inputs
            inputs'.nh.packages.default

            # Packages from my config
            config.packages.swch
            config.packages.nvf

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
            mprocs
          ]);

        shellHook =
          # bash
          ''
            ${config.pre-commit.installationScript}
            ${installCommitMsgHook}
            onefetch

            cat <<-markdown | gum format
            # ${description}

            ${longDescription}

            ## Commands

            Type \`mask --help\` to see available development commands.
            markdown
          '';
      };
  };
}
