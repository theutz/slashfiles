{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod {
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
    nhhs = ''nh home switch -b "''$(date +%s).bak"'';
    nhos = "nh os switch";
    nhds = "nh darwin switch";
  };
}
