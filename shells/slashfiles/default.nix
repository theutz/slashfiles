{
  lib,
  namespace,
  pkgs,
  mkShell,
  inputs,
  system,
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

    NH_FLAKE = "/home/michael/slashfiles";
    NH_DARWIN_FLAKE = "/etc/nix-darwin";
    EDITOR = lib.getExe pkgs.${namespace}.nvf;

    packages = with pkgs; [
      git
      onefetch
      gum
      nh
      comma
      watchexec
      yazi
      fd
      ripgrep
      btop
      lazygit
      inputs.nixos-anywhere.packages.${system}.default

      pkgs."${namespace}".nvf
      pkgs."${namespace}".swch
      pkgs."${namespace}".home
      pkgs."${namespace}".comt
      pkgs."${namespace}".searchix

      (import ./secrets.nix {inherit pkgs;})
      (import ./watch.nix {inherit pkgs;})
    ];

    shellHook =
      # bash
      ''
        onefetch
        cat <<-markdown | gum format
        # ${description}

        ${longDescription}

        ## Git Status
        markdown

        gum style --border="rounded" --margin="1 2" --padding="1 2" -- \
          "$(git -c status.color=always status -sb)"
      '';
  }
