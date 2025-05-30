{
  inputs',
  pkgs,
  packages,
  lib,
  ...
}: {
  brew.enable = true;

  environment = {
    etc."pam.d/sudo_local".text = ''
      auth    optional        ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
      auth    sufficient      pam_tid.so
    '';

    pathsToLink = [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];

    shellAliases = {
      gcam = "git commit --all --message";
      gcm = "git commit --message";
      gf = "git fetch";
      gfm = "git pull";
      gpp = "git pull && git push";
      gws = "git status --short";
      gwS = "git status";
      la = "ls -la";
      ll = "ls -l";
      nd = "man 5 configuration.nix";
      nvf = "man 5 nvf";
      hm = "man 5 home-configuration.nix";
    };

    shells = with pkgs; [
      bashInteractive
      fish
      zsh
      nushell
    ];

    systemPackages = [
      # Packages from my flake inputs
      inputs'.nh.packages.default

      # Setup Neovim Flake
      inputs'.nvf.packages.docs-manpages # generate manpages
      packages.nvf

      # Normal nixpkgs packages
      pkgs.ripgrep
      pkgs.pam-reattach
      pkgs.fd
      pkgs.git
    ];

    variables = {
      EDITOR = lib.mkForce (lib.getExe packages.nvf);
      NH_FLAKE = "/etc/nix-darwin";
    };
  };

  homebrew = {
    enable = true;
    brews = [
      "dark-mode"
    ];
    casks = [
      "vivaldi"
      "karabiner-elements"
      "spotify"
      "slack"
      "telegram"
      "mouseless@preview"
    ];
    onActivation = {
      autoUpdate = false; # default
      cleanup = "zap";
    };
    taps = [];
  };

  home-manager = {
    backupFileExtension = "bak";
    useUserPackages = true;
    useGlobalPkgs = true;
    users.michael = ../../homes/michael;
    extraSpecialArgs = {inherit packages;};
  };

  nix = {
    enable = true;
    checkConfig = true;
    # nix.nixPath.nixpkgs = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    fish.enable = true;

    man.enable = true;

    nix-index.enable = true;

    vim.enable = true;
    vim.enableSensible = true;

    zsh = {
      enable = true;
      enableBashCompletion = true;
      enableCompletion = true;
      enableFastSyntaxHighlighting = true;
      enableFzfCompletion = true;
      enableFzfGit = true;
      enableFzfHistory = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  services = {
    # FIXME: When https://github.com/nix-darwin/nix-darwin/issues/1041 is fixed, we can use
    # Karabiner Elements services through nix. Until then, c'est la vie.
    # services.karabiner-elements = {
    #         enable = true;
    #         package = pkgs.karabiner-elements.overrideAttrs (old: {
    #               version = "15.3.0";
    #
    #               src = pkgs.fetchurl {
    #                       inherit (old.src) url;
    #                       hash = "sha256-Szf2mBC8c4JA3Ky4QPTvS4GJ0PXFbN0Y7Rpum9lRABE=";
    #               };
    #
    #               dontFixup = true;
    #         });
    # };

    aerospace = {
      enable = true;
      settings.gaps.outer = pkgs.lib.genAttrs ["left" "right" "top" "bottom"] (_x: 16);
    };
  };

  system = {
    checks.verifyBuildUsers = true;
    checks.verifyNixPath = false; # not useful with flakes
    primaryUser = "michael";
    stateVersion = 5;
  };

  users.users.michael = {
    description = "Michael Utz";
    home = "/Users/michael";
    shell = pkgs.zsh;
    uid = 501;
  };
}
