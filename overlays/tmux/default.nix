{channels, ...}: _: _: {
  tmux =
    channels.unstable.tmux
    // {
      src = channels.unstable.fetchFromGitHub {
        owner = "tmux";
        repo = "tmux";
        rev = "43e88c892d41181088b2ff7908e2f2467fd30916";
        hash = "";
      };
    };
}
