{
  projectRootFile = "flake.nix";

  enableDefaultExcludes = true;

  settings.global.excludes = [
    "*.age"
    "*.sops*"
    "*.envrc"
  ];

  programs.deadnix.enable = true;

  programs.nixfmt.enable = true;

  programs.shellcheck.enable = true;

  programs.shfmt.enable = true;
  programs.shfmt.indent_size = 2;

  programs.taplo.enable = true;
}
