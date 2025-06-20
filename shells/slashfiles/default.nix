{
  namespace,
  pkgs,
  mkShell,
  ...
}: let
  name = "slashfiles";
  description = "/slashfiles: .dotfiles{everywhere}.nix";

  longDescription = ''
    The default development shell for my Nix flake.
  '';
in
  mkShell {
    inherit name;
    meta = {inherit description longDescription;};

    NH_FLAKE = "/etc/nix-darwin";

    packages =
      (with pkgs; [
        git
        onefetch
        gum
        nh
        comma
        watchexec
      ])
      ++ (with pkgs.${namespace}; [
        nvf
        swch
        home
        comt
        searchix
      ])
      ++ [
        (import ./secrets.nix {inherit pkgs;})
        (import ./watch.nix {inherit pkgs;})
      ];

    shellHook =
      # bash
      ''
        cat <<-markdown | gum format
        # ${description}

        ${longDescription}

        ## Git Status
        markdown

        gum style --border="rounded" --margin="1 2" --padding="1 2" -- \
          "$(git -c status.color=always status -sb)"
      '';
  }
