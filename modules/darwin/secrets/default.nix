{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "spotify_player/client_id" = {
        owner = "michael";
        group = "staff";
        mode = "0400";
      };
    };
  };
}
