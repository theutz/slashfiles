_: _final: prev: {
  qutebrowser =
    if prev.stdenv.isLinux then
      prev.qutebrowser.override {
        enableWideVine = true;
      }
    else
      prev.qutebrowser;
}
