{ pkgs, namespace, inputs, system, ...  }: {
        environment.shellAliases = {
                gcam = "git commit --all --message";
                gcm = "git commit --message";
                gf = "git fetch";
                gfm = "git pull";
                gpp = "git pull && git push";
                gws = "git status --short";
                gwS = "git status";
        };
        environment.shells = with pkgs; [
                bashInteractive
                fish
                zsh
                nushell
        ];
        environment.systemPackages = (with pkgs; [
                ripgrep
                pam-reattach
                inputs.nvf.packages.${system}.docs-manpages
        ]) ++ (with pkgs.${namespace}; [
                nvim
        ]);
        environment.etc."pam.d/sudo_local" = {
                text = ''
                        auth    optional        ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
                        auth    sufficient      pam_tid.so
                '';
        };
        homebrew = {
                enable = true;
                brews = [];
                casks = [
                        "vivaldi"
                        "karabiner-elements"
                ];
                onActivation = {
                        autoUpdate = false; # default
                        cleanup = "zap";
                };
                taps = [];
        };
	home-manager = {
		backupFileExtension = "bak";
		useUserPackages = true;
		useGlobalPkgs = true;
	};
	nix = {
                enable = true;
		checkConfig = true;
		nixPath = {
			nixpkgs = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
		};
	};
	programs.fish.enable = true;
        programs.man.enable = true;
        programs.nix-index.enable = true;
        programs.tmux = {
                enable = true;
                enableSensible = true;
                enableFzf = true;
                enableMouse = true;
                enableVim = true;
        };
        programs.vim = {
                enable = true;
                enableSensible = true;
        };
        programs.zsh = {
                enable = true;
                enableBashCompletion = true;
                enableCompletion = true;
                enableFastSyntaxHighlighting = true;
                enableFzfCompletion = true;
                enableFzfGit = true;
                enableFzfHistory = true;
	};
        security = {
                pam = {
                        services = {
                                sudo_local = {
                                        touchIdAuth = true;
                                };
                        };
                };
        };
	services = {
                aerospace = {
                        enable = true;
                        settings = {
                                gaps = let
                                        gap = 8;
                                in {
                                        outer = {
                                          left = gap;
                                          right = gap;
                                          top = gap;
                                          bottom = gap;
                                        };
                                };
                        };
                };
                # FIXME: When https://github.com/nix-darwin/nix-darwin/issues/1041 is fixed, we can use
                # Karabiner Elements services through nix. Until then, c'est la vie.
                # karabiner-elements = {
                #         enable = true;
                #         package = pkgs.karabiner-elements.overrideAttrs (old: {
                #               version = "15.3.0";
                #
                #               src = pkgs.fetchurl {
                #                       inherit (old.src) url;
                #                       hash = "sha256-Szf2mBC8c4JA3Ky4QPTvS4GJ0PXFbN0Y7Rpum9lRABE=";
                #               };
                #
                #               dontFixup = true;
                #         });
                # };
	};
	system = {
		checks = {
			verifyBuildUsers = true;
			verifyNixPath = false; # not useful with flakes
		};
                primaryUser = "michael";
		stateVersion = 5;
	};
	users = {
		users.michael = {
			description = "Michael Utz";
			home = "/Users/michael";
                        shell = pkgs.zsh;
			uid = 501;
		};
	};
}
