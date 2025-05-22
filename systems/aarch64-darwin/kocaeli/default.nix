{ pkgs, ...  }: {
	environment = {
		systemPackages = with pkgs; [
			lazygit
			just
		];
	};

	programs = {
		zsh = {
			enable = true;
		};

		fish = {
			enable = true;
		};
	};

	system = {
		stateVersion = 5;
	};
}
