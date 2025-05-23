{ pkgs, ...  }: {
	environment = {
                shellAliases = {
                        gcam = "git commit --all --message";
                        gcm = "git commit --message";
                        gf = "git fetch";
                        gfm = "git pull";
                        gpp = "git pull && git push";
                        gwS = "git status";
                        gws = "git status --short";
                };

                shells = with pkgs; [
                        bashInteractive
                        fish
                        zsh
                ];

		systemPackages = with pkgs; [
			lazygit
			mask
                        ripgrep
                        fd
		];
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

	programs = {
		fish = {
			enable = true;
		};

                man = {
                        enable = true;
                };

                nix-index = {
                        enable = true;
                };

                tmux = {
                        enable = true;
                        enableSensible = true;
                        enableFzf = true;
                        enableMouse = true;
                        enableVim = true;
                };

                vim = {
                        enable = true;
                        enableSensible = true;
                };

		zsh = {
			enable = true;
                        enableBashCompletion = true;
                        enableCompletion = true;
                        enableFastSyntaxHighlighting = true;
                        enableFzfCompletion = true;
                        enableFzfGit = true;
                        enableFzfHistory = true;

                        # mutually exclusive with enableFastSyntaxHighlighting
                        # enableSyntaxHighlighting = true; 
		};
	};

	services = {
	};

	system = {
		stateVersion = 5;
		checks = {
			verifyBuildUsers = true;
			verifyNixPath = false; # not useful with flakes
		};
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
