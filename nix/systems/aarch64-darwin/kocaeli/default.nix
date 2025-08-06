{
  system,
  ...
}:
{
  # "${namespace}" = {
  #   pam.enable = true;
  #   pkgs.enable = true;
  #   secrets.enable = true;
  # };

  snowfallorg.users.michael.home.enable = false;

  # snowfallorg.users."michael@kocaeli" = {
  #   create = true;
  #   # FIXME: Figure out why this doesn't work
  #   # admin = true;
  #   home = {
  #     enable = true;
  #     path = "/Users/michael";
  #   };
  # };

  # environment = {
  #   pathsToLink = [
  #     "/opt/homebrew/bin"
  #     "/opt/homebrew/sbin"
  #   ];
  #
  #   shellAliases = {
  #     la = "ls -la";
  #     ll = "ls -l";
  #     nd = "man 5 configuration.nix";
  #     nvf = "man 5 nvf";
  #     hm = "man 5 home-configuration.nix";
  #   };
  #
  #   systemPackages =
  #     with pkgs;
  #     [
  #       nvf-man
  #     ]
  #     ++ (with pkgs.${namespace}; [
  #       nvf
  #       swch
  #       comt
  #     ]);
  #
  #   variables = {
  #     EDITOR = lib.mkForce (lib.getExe pkgs.${namespace}.nvf);
  #     NH_FLAKE = "/etc/nix-darwin";
  #   };
  # };
  #
  # nix = {
  #   enable = true;
  #   checkConfig = true;
  #   gc = {
  #     automatic = true;
  #   };
  #   linux-builder = {
  #     enable = true;
  #     systems = [
  #       "x86_64-linux"
  #       "aarch64-linux"
  #     ];
  #     ephemeral = true;
  #     config.boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
  #     maxJobs = 8;
  #     # config = {
  #     #   virtualisation = {
  #     #     darwin-builder = {
  #     #       diskSize = 40 * 1024;
  #     #       memorySize = 8 * 1024;
  #     #     };
  #     #     cores = 6;
  #     #   };
  #     # };
  #   };
  #   optimise = {
  #     automatic = true;
  #   };
  #   registry = {
  #     nixpkgs = {
  #       from = {
  #         id = "nixpkgs";
  #         type = "indirect";
  #       };
  #       to = {
  #         owner = "nixos";
  #         repo = "nixpkgs";
  #         type = "github";
  #         ref = "nixpkgs-25.05-darwin";
  #       };
  #     };
  #     unstable = {
  #       from = {
  #         id = "unstable";
  #         type = "indirect";
  #       };
  #       to = {
  #         owner = "nixos";
  #         repo = "nixpkgs";
  #         type = "github";
  #         ref = "nixpkgs-unstable";
  #       };
  #     };
  #   };
  #   settings = {
  #     experimental-features = [
  #       "nix-command"
  #       "flakes"
  #       "pipe-operators"
  #     ];
  #     trusted-users = [ "@admin" ];
  #   };
  # };

  nix.settings.experimental-features = [
    "nix-command"
    "pipe-operators"
    "flakes"
  ];

  #
  # nixpkgs.config.allowUnfree = true;
  #
  # programs = {
  #   fish.enable = true;
  #
  #   man.enable = true;
  #
  #   nix-index.enable = true;
  #
  #   vim.enable = true;
  #   vim.enableSensible = true;
  #
  #   zsh = {
  #     enable = true;
  #     enableBashCompletion = true;
  #     enableCompletion = true;
  #     enableFastSyntaxHighlighting = true;
  #     enableFzfCompletion = true;
  #     enableFzfGit = true;
  #     enableFzfHistory = true;
  #   };
  # };
  #
  # services = {
  #   # FIXME: When https://github.com/nix-darwin/nix-darwin/issues/1041 is fixed, we can use
  #   # Karabiner Elements services through nix. Until then, c'est la vie.
  #   # services.karabiner-elements = {
  #   #         enable = true;
  #   #         package = pkgs.karabiner-elements.overrideAttrs (old: {
  #   #               version = "15.3.0";
  #   #
  #   #               src = pkgs.fetchurl {
  #   #                       inherit (old.src) url;
  #   #                       hash = "sha256-Szf2mBC8c4JA3Ky4QPTvS4GJ0PXFbN0Y7Rpum9lRABE=";
  #   #               };
  #   #
  #   #               dontFixup = true;
  #   #         });
  #   # };
  # };
  #
  # system = {
  #   checks.verifyBuildUsers = true;
  #   checks.verifyNixPath = false; # not useful with flakes
  #   primaryUser = lib.${namespace}.prefs.user;
  #   stateVersion = 5;
  # };
  #
  # # users.users.michael = {
  # #   description = "Michael Utz";
  # #   home = "/Users/michael";
  # #   shell = pkgs.zsh;
  # #   uid = 501;
  # # };
  system.stateVersion = 5;
}
