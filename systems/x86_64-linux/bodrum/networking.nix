{ namespace, lib, ... }:
{
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  ${namespace} = lib.${namespace}.genEnabledMods ''
    tailscale
  '';
}
