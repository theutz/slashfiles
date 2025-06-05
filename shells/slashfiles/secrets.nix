{pkgs, ...}:
pkgs.writeShellApplication {
  name = "sop";
  meta.description = "edit the sops file";

  runtimeInputs = with pkgs; [sops];

  runtimeEnv = {
    SOPS_FILE = "secrets.yaml";
  };

  text =
    # bash
    ''
      file="''${NH_FLAKE}/''${SOPS_FILE}"
      sops edit "$file"
    '';
}
