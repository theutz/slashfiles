{
  pkgs,
  ...
}:
pkgs.buildGoModule (finalAttrs: {
  pname = builtins.baseNameOf ./.;
  version = "v0.11.0";
  meta = {
    description = ''
      Interactive Git-based todo-list for the command line.
    '';
    homepage = "https://github.com/handlebargh/yatto";
    licenses = with pkgs.license; [ mit ];
    mainProgram = finalAttrs.pname;
  };

  src = pkgs.fetchFromGitHub {
    owner = "handlebargh";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-W0rhPTnVb+GO2kJEwofcvmVXd36X9zMgXHaK82vqeIQ=";
  };

  vendorHash = "sha256-okCjA4Kgc40eP+bhK/GkjJ7QOhY9P4I/YkHJh67VEQo=";
})
