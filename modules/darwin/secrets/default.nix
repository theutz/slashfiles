{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops.defaultSopsFile = ./secrets.yaml;
}
