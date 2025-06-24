{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  imports =
    (./machines |> lib.filesystem.listFilesRecursive)
    ++ [
      ./options.nix
      ./users.nix
    ];

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
      age
    ];

    sops = {
      defaultSopsFile = ../../../secrets.yaml;

      secrets = {
        "spotify_player/client_id" = cfg.mine;
        "openai" = cfg.mine;
        "gemini" = cfg.mine;
        "anthropic" = cfg.mine;
      };
    };
  };
}
