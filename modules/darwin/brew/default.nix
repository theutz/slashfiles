{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      onefetch
    ];
  };
}
