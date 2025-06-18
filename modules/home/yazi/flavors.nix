{pkgs, ...}: {
  rose-pine = pkgs.fetchFromGitHub {
    owner = "jamylak";
    repo = "rose-pine.yazi";
    rev = "df10f50";
    hash = "sha256-y+MVU6y73dLXiTrzkbG6/xc0xKcZyywBCZabVL6nAQg=";
  };

  flexoki-light = pkgs.fetchFromGitHub {
    owner = "gosxrgxx";
    repo = "flexoki-light.yazi";
    rev = "45eb0a0f9860eaa93146587b4d4be97b46699a38";
    hash = "sha256-fEGAxeyeWD6HBKTmhAhKGNGb5LsYPR0Y2I4B5adpv9M=";
  };

  flexoki-dark = pkgs.fetchFromGitHub {
    owner = "gosxrgxx";
    repo = "flexoki-dark.yazi";
    rev = "28e1977108e3fc79d4253db821eef1b0ae2b4c18";
    hash = "sha256-fEGAxeyeWD6HBKTmhAhKGNGb5LsYPR0Y2I4B5adpv9M=";
  };

  kanagawa = pkgs.fetchFromGitHub {
    owner = "dangooddd";
    repo = "kanagawa.yazi";
    rev = "31167ed54c9cc935b2fa448d64d367b1e5a1105d";
    hash = "sha256-phwGd1i/n0mZH/7Ukf1FXwVgYRbXQEWlNRPCrmR5uNk=";
  };

  kanagawa-dragon = pkgs.fetchFromGitHub {
    owner = "marcosvnmelo";
    repo = "kanagawa-dragon.yazi";
    rev = "49055274ff53772a13a8c092188e4f6d148d1694";
    hash = "sha256-phwGd1i/n0mZH/7Ukf1FXwVgYRbXQEWlNRPCrmR5uNk=";
  };

  kanagawa-lotus = pkgs.fetchFromGitHub {
    owner = "muratoffalex";
    repo = "kanagawa-lotus.yazi";
    rev = "d84d61a0b19de7b13faf9f2f27e2a1070de0790e";
    hash = "sha256-uNilaHKpTlHD/8E7CugpsH0swjkqNiUvm04TGd3KMeQ=";
  };
}
