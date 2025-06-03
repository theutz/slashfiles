{
  lib,
  config,
  namespace,
  ...
}:
lib.${namespace}.mkModule {
  inherit config;
  here = ./.;
} ({cfg}: {
  options.enable = lib.mkEnableOption "git-based tool options";

  config = lib.mkIf cfg.enable {
    programs.gh.enable = true;
    programs.git = {
      enable = true;
      ignores = ["*~" "*.swp" "*.log"];
      userName = "Michael Utz";
      userEmail = "michael@theutz.com";
      delta = {
        enable = true;
      };
    };
  };
})
