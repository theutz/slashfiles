{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod {
  home.packages =
    with pkgs;
    lib.optionals pkgs.stdenv.isLinux [
      wayprompt
    ];

  programs.gpg = {
    enable = true;
    settings = {
      auto-key-retrieve = true;
      no-emit-version = true;
      default-key = "20EAD87446896C423CA9C6C1651A36416AEFB22E";
      keyid-format = "SHORT";
      armor = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 84000;
    maxCacheTtl = 84000;
    pinentry = lib.mkIf pkgs.stdenv.isLinux {
      package = pkgs.wayprompt;
      program = "pinentry-wayprompt";
    };
    # pinentry-program /opt/homebrew/bin/pinentry-mac
  };
}
