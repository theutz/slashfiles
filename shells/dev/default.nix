{ pkgs, mkShell, ... }: mkShell {
        packages = with pkgs; [
                watchexec
                zsh
                mask
        ];

        shellHook = /* bash */ ''
                alias d='mask dev'
                alias r='exec mask reload'

                echo "Run 'mask dev' to watch for changes"
        '';
}
