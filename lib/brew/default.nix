{
  lib,
  ...
}:
let
  prefix = "/opt/homebrew";
in
{
  brew = rec {
    path = {
      bin = prefix + "/bin";
      sbin = prefix + "/sbin";
    };

    paths = lib.mapAttrsToList (_name: value: value) path;

    getBin =
      exe:
      lib.concatStringsSep "/" [
        path.bin
        exe
      ];

    getSbin =
      exe:
      lib.concatStringsSep "/" [
        path.sbin
        exe
      ];

    exe = getBin "brew";

    install = {
      formula = pkg: "${exe} install ${pkg}";
      Cask = pkg: "${exe} install --cask ${pkg}";
    };
  };
}
