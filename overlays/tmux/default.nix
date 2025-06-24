{channels, ...}: _: _: {
  tmux =
    channels.unstable.tmux.overrideAttrs
    {
      src = channels.unstable.fetchFromGitHub {
        owner = "tmux";
        repo = "tmux";
        rev = "43e88c892d41181088b2ff7908e2f2467fd30916";
        hash = "sha256-RCZfUnUHQuPrjPE01SMeVvT772Ob5xqaGboxMCjOIKg=";
      };
    };
}
