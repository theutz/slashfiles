{ pkgs, ... }: 
let
	inherit (pkgs.stdenv) isDarwin;
in
{
	home = {
		username = "michael";
		stateVersion = "24.11";
		homeDirectory = if isDarwin then "/Users/michael" else "/home/michael";
	};

	programs.git = {
		userName = "Michael Utz";
		userEmail = "michael@theutz.com";
	};
}
