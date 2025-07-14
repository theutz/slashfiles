{
  # Install nix-index
  programs.nix-index.enable = true;
  programs.nix-index.enableBashIntegration = true;
  programs.nix-index.enableFishIntegration = true;
  programs.nix-index.enableZshIntegration = true;
  programs.command-not-found.enable = false;
}
