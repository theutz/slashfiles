{ namespace, lib, ... }:
{
  ${namespace} = lib.${namespace}.genEnabledMods ''
    tailscale
  '';
}
