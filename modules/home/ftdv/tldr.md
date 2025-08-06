# ftdv (File Tree Diff Viewer)

> ftdv (File Tree Diff Viewer) is a terminal-based diff viewer inspired by
> diffnav and lazygit. It combines diffnav's intuitive file navigation with
> lazygit's flexible diff tool configuration system, providing an interactive
> interface for viewing git diffs with support for various diff tools like
> delta, bat, ydiff, and difftastic.

- View working directory changes (default)

`ftdv`

- View staged changes

`ftdv --cached`

- Compare with a specific commit/branch

`ftdv main`

- Compare two commits/branches

`ftdv main feature-branch`

- Compare two files

`ftdv file1.txt file2.txt`

- Compare two directories

`ftdv dir1/ dir2/`
