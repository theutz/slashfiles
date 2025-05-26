{ pkgs, mkShell, ... }: mkShell {
        packages = with pkgs; [
                watchexec
                zsh
                mask
                mise
        ];

        shellHook = /* bash */ ''
                echo "Run 'mask dev' to watch for changes"
        '';
}
