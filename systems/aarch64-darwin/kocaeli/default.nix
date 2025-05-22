{
	namespace,
	lib,
	...
}: {
	imports = lib.pipe ./. [
		lib.filesystem.listFilesRecursive
		(lib.filter (f: f != ./default.nix))
	];

	"${namespace}" = {
          system.enable = true;
	# 	home-manager.enable = true;
	# 	nix.enable = true;
	};

	programs.zsh.enable = true;
}
