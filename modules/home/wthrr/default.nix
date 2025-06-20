{
  namespace,
  lib,
  config,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config |> lib.getAttrFromPath [namespace mod];
in {
  options.${namespace}.${mod} = {
    # https://github.com/ttytm/wthrr-the-weathercrab
    enable = lib.mkEnableOption "enable wthrr - the weather crab";
  };

  config.${namespace}.${mod} = lib.mkIf cfg.enable {};
}
