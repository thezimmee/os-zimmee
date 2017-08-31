# Git (including GitHub and BitBucket) Cheatsheet

> Cheatsheet for git, [GitHub](https://github.com/), and [BitBucket](https://bitbucket.org/).

<!-- MarkdownTOC depth=2 -->

1. [Keep a repo in sync with another repo](#keep-a-repo-in-sync-with-another-repo)
1. [Reset `.gitignore` cache to ignore files that were previously committed](#reset-gitignore-cache-to-ignore-files-that-were-previously-committed)

<!-- /MarkdownTOC -->

<a name="keep-a-repo-in-sync-with-another-repo"></a>
## Keep a repo in sync with another repo

This describes how to keep a repo in sync with a repo other than its `origin`.

```bash
# Setup local repo.
mkdir <my-directory> && cd <my-directory>
git init

# Add "origin" remote repo (in this case, a BitBucket repo).
git remote add origin ssh://git@bitbucket.org/aleemb/<my-directory>.git

# Add "sync" remote repo (in this case, a GitHub repo).
git remote add sync https://github.com/<github-user>/<github-repo>.git

# To verify the remote URLs:
git remote -v
# This should show URLs for both "origin" and "sync" remotes.

# Pull the "sync" repo:
git pull sync

# Create a "github" branch to track "sync" remote's "master" branch:
git branch --track github sync/master

# ...and switch to the "github" branch:
git checkout github

# Create a new master branch from the github branch:
git checkout -b master

# push local "master" branch to "origin" remote (bitbucket)
git push -u origin master
```

<a name="reset-gitignore-cache-to-ignore-files-that-were-previously-committed"></a>
## Reset `.gitignore` cache to ignore files that were previously committed

```bash
git rm -r --cached .
# OR
git rm -r --cached <file>
```
