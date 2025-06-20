{channels, ...}: _: _: {
  inherit (channels.nixpkgs-swift-update) swift xcbuildHook;
  swiftPackages = {
    inherit (channels.nixpkgs-swift-update) stdenv;
  };
}
