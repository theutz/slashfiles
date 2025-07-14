{
  config,
  namespace,
  lib,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      backupFileExtension = "bak";
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}
