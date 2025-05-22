{
	namespace, config, lib, ...
}: {
	options.${namespace}.system.enable = lib.mkEnableOption "nix-darwin system settings";

	config = {
		system = {
			checks = {
				verifyBuildUsers = true;
				verifyNixChannels = true;
				verifyNixPath = false; # not useful with flakes
			};
		};
	};
}
