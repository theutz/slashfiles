{ pkgs, mkShell, ... }: mkShell {
        packages = with pkgs; [
                watchexec
                zsh
                mask
                mprocs
        ];

        shellHook = /* bash */ ''
                alias dev='mask dev'

                echo "Run 'dev' to watch for changes"
        '';
}
