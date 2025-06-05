{
  config.home.shellAliases = let
    _git_log_medium_format = ''%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'';
    _git_log_oneline_format = "%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n";
    _git_log_brief_format = "%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n";
  in {
    # Git
    g = "git";

    # Branch (b)
    gb = "git branch";
    gba = "git branch --all --verbose";
    gbc = "git checkout -b";
    gbd = "git branch --delete";
    gbD = "git branch --delete --force";
    gbl = "git branch --verbose";
    gbL = "git branch --all --verbose";
    gbm = "git branch --move";
    gbM = "git branch --move --force";
    gbr = "git branch --move";
    gbR = "git branch --move --force";
    gbs = "git show-branch";
    gbS = "git show-branch --all";
    gbv = "git branch --verbose";
    gbV = "git branch --verbose --verbose";
    gbx = "git branch --delete";
    gbX = "git branch --delete --force";

    # Commit (c)
    gc = "git commit --verbose";
    gcS = "git commit --verbose --gpg-sign";
    gca = "git commit --verbose --all";
    gcaS = "git commit --verbose --all --gpg-sign";
    gcm = "git commit --message";
    gcmS = "git commit --message --gpg-sign";
    gcam = "git commit --all --message";
    gco = "git checkout";
    gcO = "git checkout --patch";
    gcf = "git commit --amend --reuse-message HEAD";
    gcfS = "git commit --amend --reuse-message HEAD --gpg-sign";
    gcF = "git commit --verbose --amend";
    gcFS = "git commit --verbose --amend --gpg-sign";
    gcp = "git cherry-pick --ff";
    gcP = "git cherry-pick --no-commit";
    gcr = "git revert";
    gcR = ''git reset "HEAD^"'';
    gcs = "git show";
    gcsS = "git show --pretty=short --show-signature";
    gcy = "git cherry --verbose --abbrev";
    gcY = "git cherry --verbose";

    # Conflict (C)
    gCl = "git --no-pager diff --name-only --diff-filter=U";
    gCa = "git add $(gCl)";
    gCe = "git mergetool $(gCl)";
    gCo = "git checkout --ours --";
    gCO = "gCo $(gCl)";
    gCt = "git checkout --theirs --";
    gCT = "gCt $(gCl)";

    # Data (d)
    gd = "git ls-files";
    gdc = "git ls-files --cached";
    gdx = "git ls-files --deleted";
    gdm = "git ls-files --modified";
    gdu = "git ls-files --other --exclude-standard";
    gdk = "git ls-files --killed";
    gdi = ''git status --porcelain --short --ignored | sed -n "s/^!! //p"'';

    # Fetch (f)
    gf = "git fetch";
    gfa = "git fetch --all";
    gfc = "git clone";
    gfcr = "git clone --recurse-submodules";
    gfm = "git pull";
    gfma = "git pull --autostash";
    gfr = "git pull --rebase";
    gfra = "git pull --rebase --autostash";

    # Flow (F)
    gFi = "git flow init";
    gFf = "git flow feature";
    gFb = "git flow bugfix";
    gFl = "git flow release";
    gFh = "git flow hotfix";
    gFs = "git flow support";

    gFfl = "git flow feature list";
    gFfs = "git flow feature start";
    gFff = "git flow feature finish";
    gFfp = "git flow feature publish";
    gFft = "git flow feature track";
    gFfd = "git flow feature diff";
    gFfr = "git flow feature rebase";
    gFfc = "git flow feature checkout";
    gFfm = "git flow feature pull";
    gFfx = "git flow feature delete";

    gFbl = "git flow bugfix list";
    gFbs = "git flow bugfix start";
    gFbf = "git flow bugfix finish";
    gFbp = "git flow bugfix publish";
    gFbt = "git flow bugfix track";
    gFbd = "git flow bugfix diff";
    gFbr = "git flow bugfix rebase";
    gFbc = "git flow bugfix checkout";
    gFbm = "git flow bugfix pull";
    gFbx = "git flow bugfix delete";

    gFll = "git flow release list";
    gFls = "git flow release start";
    gFlf = "git flow release finish";
    gFlp = "git flow release publish";
    gFlt = "git flow release track";
    gFld = "git flow release diff";
    gFlr = "git flow release rebase";
    gFlc = "git flow release checkout";
    gFlm = "git flow release pull";
    gFlx = "git flow release delete";

    gFhl = "git flow hotfix list";
    gFhs = "git flow hotfix start";
    gFhf = "git flow hotfix finish";
    gFhp = "git flow hotfix publish";
    gFht = "git flow hotfix track";
    gFhd = "git flow hotfix diff";
    gFhr = "git flow hotfix rebase";
    gFhc = "git flow hotfix checkout";
    gFhm = "git flow hotfix pull";
    gFhx = "git flow hotfix delete";

    gFsl = "git flow support list";
    gFss = "git flow support start";
    gFsf = "git flow support finish";
    gFsp = "git flow support publish";
    gFst = "git flow support track";
    gFsd = "git flow support diff";
    gFsr = "git flow support rebase";
    gFsc = "git flow support checkout";
    gFsm = "git flow support pull";
    gFsx = "git flow support delete";

    # Grep (g)
    gg = "git grep";
    ggi = "git grep --ignore-case";
    ggl = "git grep --files-with-matches";
    ggL = "git grep --files-without-matches";
    ggv = "git grep --invert-match";
    ggw = "git grep --word-regexp";

    # Index (i)
    gia = "git add";
    giA = "git add --patch";
    giu = "git add --update";
    gid = "git diff --no-ext-diff --cached";
    giD = "git diff --no-ext-diff --cached --word-diff";
    gii = "git update-index --assume-unchanged";
    giI = "git update-index --no-assume-unchanged";
    gir = "git reset";
    giR = "git reset --patch";
    gix = "git rm -r --cached";
    giX = "git rm -r --force --cached";

    # Log (l)
    gl = ''git log --topo-order --pretty=format:"${_git_log_medium_format}"'';
    gls = ''git log --topo-order --stat --pretty=format:"${_git_log_medium_format}"'';
    gld = ''git log --topo-order --stat --patch --full-diff --pretty=format:"${_git_log_medium_format}"'';
    glo = ''git log --topo-order --pretty=format:"${_git_log_oneline_format}"'';
    glg = ''git log --topo-order --graph --pretty=format:"${_git_log_oneline_format}"'';
    glb = ''git log --topo-order --pretty=format:"${_git_log_brief_format}"'';
    glc = "git shortlog --summary --numbered";
    glS = "git log --show-signature";

    # Merge (m)
    gm = "git merge";
    gmC = "git merge --no-commit";
    gmF = "git merge --no-ff";
    gma = "git merge --abort";
    gmt = "git mergetool";

    # Push (p)
    gp = "git push";
    gpf = "git push --force-with-lease";
    gpF = "git push --force";
    gpa = "git push --all";
    gpA = "git push --all && git push --tags";
    gpt = "git push --tags";
    gpc = ''git push --set-upstream origin'';
    gpp = ''git pull && git push'';

    # Rebase (r)
    gr = "git rebase";
    gra = "git rebase --abort";
    grc = "git rebase --continue";
    gri = "git rebase --interactive";
    grs = "git rebase --skip";

    # Remote (R)
    gR = "git remote";
    gRl = "git remote --verbose";
    gRa = "git remote add";
    gRx = "git remote rm";
    gRm = "git remote rename";
    gRu = "git remote update";
    gRp = "git remote prune";
    gRs = "git remote show";

    # Stash (s)
    gs = "git stash";
    gsa = "git stash apply";
    gsx = "git stash drop";
    gsl = "git stash list";
    gsd = "git stash show --patch --stat";
    gsp = "git stash pop";
    gss = "git stash save --include-untracked";
    gsS = "git stash save --patch --no-keep-index";
    gsw = "git stash save --include-untracked --keep-index";

    # Submodule (S)
    gS = "git submodule";
    gSa = "git submodule add";
    gSf = "git submodule foreach";
    gSi = "git submodule init";
    gSI = "git submodule update --init --recursive";
    gSl = "git submodule status";
    gSs = "git submodule sync";
    gSu = "git submodule update --remote --recursive";

    # Tag (t)
    gt = "git tag";
    gtl = "git tag --list";
    gts = "git tag --sign";
    gtv = "git verify-tag";

    # Working Copy (w)
    gws = "git status --ignore-submodules='none' --short";
    gwS = "git status --ignore-submodules='none'";
    gwd = "git diff --no-ext-diff";
    gwD = "git diff --no-ext-diff --word-diff";
    gwr = "git reset --soft";
    gwR = "git reset --hard";
    gwc = "git clean --dry-run";
    gwC = "git clean --force";
    gwx = "git rm -r";
    gwX = "git rm -r --force";
  };
}
