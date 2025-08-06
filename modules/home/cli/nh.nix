{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkConfig;
in
{
  config = mkConfig {
    home.packages = with pkgs; [
      nix-output-monitor
    ];

    programs.nh = {
      enable = true;
      clean.enable = true;
      flake = lib.concatStringsSep "/" [
        config.home.homeDirectory
        namespace
      ];
    };

    home.shellAliases = {
      nhs = ''nh home switch -b "''$(date +%s).bak"'';
      nos = if pkgs.stdenv.isLinux then "nh os switch" else "nh darwin switch";
    };
  };
}
