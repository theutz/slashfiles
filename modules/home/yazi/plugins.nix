{pkgs, ...}: {
  inherit
    (pkgs.yaziPlugins)
    chmod
    duckdb
    full-border
    git
    glow
    lazygit
    miller
    ouch
    projects
    relative-motions
    rsync
    smart-enter
    smart-filter
    smart-paste
    starship
    sudo
    vcs-files
    ;

  path-from-root = pkgs.fetchFromGitHub {
    owner = "aresler";
    repo = "path-from-root";
    rev = "7d05b87";
    hash = "sha256-JSl9S8kxD8XoN21WfJwjEGwDB+/McjrTv+8SbXvZKds=";
  };

  copy-file-contents =
    {
      owner = "AnirudhG07";
      repo = "plugins-yazi";
      rev = "524c52c";
      hash = "sha256-GrPqcHYG+qHNi80U+EJJd1JjdAOexiE6sQxsqdeCSMg=";
    }
    |> pkgs.fetchFromGitHub
    |> (p: "${p.outPath}/copy-file-contents.yazi");
}
