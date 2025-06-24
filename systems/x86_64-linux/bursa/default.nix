{
  lib,
  pkgs,
  system,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
  ];
  boot = {
    kernelParams = ["console=ttyS0,19200n8"];
    loader = {
      timeout = 10;
      grub = {
        # no need to set devices, disko will add all devices that have a EF02 partition to the list already
        # devices = [ ];
        efiSupport = true;
        efiInstallAsRemovable = true;
        forceInstall = true;
        extraConfig = ''
          serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1
          terminal_input serial
          terminal_output serial
        '';
        # device = "nodev";
      };
    };
  };

  services.openssh = {
    enable = true;
    settings = {PermitRootLogin = "yes";};
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.inetutils
    pkgs.mtr
    pkgs.sysstat
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbChuj1162NTbJx49GrPJC7qc/mBrXHcDNQO1wbNyJ5"
  ];

  system.stateVersion = "25.05";
}
