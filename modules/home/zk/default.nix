{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};

  Label = "com.${namespace}.${mod}.emanote";
  port = "3842";
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";
  };

  config = lib.mkIf cfg.enable {
    programs.zk = {
      enable = true;
      settings = {
        notebook = {
          dir = config.home.homeDirectory + "/notes";
        };
        notes = {
          language = "en";
          default-title = "untitled";
          filename = "{{id}}-{{slug title}}";
          extension = "md";
          template = "default.md";
          id-charset = "alphanum";
          id-length = 4;
          id-case = "lower";
        };
      };
    };

    home.packages = with pkgs; [emanote];

    home.shellAliases = {
      zopen = "open http://localhost:${port}";
    };

    launchd.agents.emanote = {
      enable = true;
      config = {
        inherit Label;
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/${Label}/out.log";
        StandardErrorPath = "/tmp/${Label}/err.log";
        WorkingDirectory = config.programs.zk.settings.notebook.dir;
        ProgramArguments = [
          (lib.getExe pkgs.emanote)
          "run"
          "--port=${port}"
        ];
      };
    };
  };
}
