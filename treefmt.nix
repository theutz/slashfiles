{
  projectRootFile = "flake.nix";
  enableDefaultExcludes = true;
  settings = {
    global.excludes = ["*.age" "*.sops*" "*.envrc"];
  };

  programs = {
    alejandra.enable = true;
    deadnix.enable = true;
    taplo.enable = true;
    shellcheck.enable = true;
    shfmt = {
      enable = true;
      indent_size = 2;
    };
  };
}
