{
  pkgs,
  namespace,
  inputs,
  system,
  lib,
  ...
}: {
  environment.shellAliases = {
    gcam = "git commit --all --message";
    gcm = "git commit --message";
    gf = "git fetch";
    gfm = "git pull";
    gpp = "git pull && git push";
    gws = "git status --short";
    gwS = "git status";
  };

  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
    nushell
  ];

  environment.systemPackages =
    (with pkgs; [
      ripgrep
      pam-reattach
      inputs.nvf.packages.${system}.docs-manpages
    ])
    ++ (with pkgs.${namespace}; [
      nvim
    ]);

  environment.etc."pam.d/sudo_local".text = ''
    auth    optional        ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
    auth    sufficient      pam_tid.so
  '';

  homebrew.enable = true;
  homebrew.brews = [];
  homebrew.casks = [
    "vivaldi"
    "karabiner-elements"
    "spotify"
    "slack"
    "telegram"
  ];
  homebrew.onActivation.autoUpdate = false; # default
  homebrew.onActivation.cleanup = "zap";
  homebrew.taps = [];

  home-manager.backupFileExtension = "bak";
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  nix.enable = true;
  nix.checkConfig = true;
  nix.nixPath.nixpkgs = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";

  programs.fish.enable = true;

  programs.man.enable = true;

  programs.nix-index.enable = true;

  programs.tmux.enable = true;
  programs.tmux.enableSensible = true;
  programs.tmux.enableFzf = true;
  programs.tmux.enableMouse = true;
  programs.tmux.enableVim = true;

  programs.vim.enable = true;
  programs.vim.enableSensible = true;

  programs.zsh.enable = true;
  programs.zsh.enableBashCompletion = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableFastSyntaxHighlighting = true;
  programs.zsh.enableFzfCompletion = true;
  programs.zsh.enableFzfGit = true;
  programs.zsh.enableFzfHistory = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  services.aerospace.enable = true;
  services.aerospace.settings.gaps.outer = lib.genAttrs ["left" "right" "top" "bottom"] (x: 16);

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

  system.checks.verifyBuildUsers = true;
  system.checks.verifyNixPath = false; # not useful with flakes
  system.primaryUser = "michael";
  system.stateVersion = 5;

  users.users.michael = {
    description = "Michael Utz";
    home = "/Users/michael";
    shell = pkgs.zsh;
    uid = 501;
  };
}
