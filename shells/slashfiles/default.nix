{
  inputs,
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
        inputs.nh.packages.${pkgs.system}.default

        git
        onefetch
        watchexec
        gum
        aichat
        tmux
        tmuxp
        gitu
        lazygit
      ])
      ++ (with pkgs.${namespace}; [
        nvf
        swch
        home
        comt
      ]);

    shellHook =
      # bash
      ''
        echo
        onefetch
        cat <<-markdown | gum format
        # ${description}

        ${longDescription}
        markdown

        git status
      '';
  }
