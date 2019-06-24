## GIT Helpers for ManageIQ

Following scripts iterate over core and plugins and performs useful mass operations.

### Config

[config.sh](config.sh) file contains basic settings, like your home and plugins directory of ManageIQ.  
If you want to redefine some value, create `config.dev.sh` file (excluded from git) and override variable.

### Repositories

List of repositories are either generated automatically (`$custom_repo_list == 0`) or you can define your own array manually
(`$custom_repo_list == 1`). See config for example. 

### Scripts

Following scripts are working on current (one) repository

- [pull.sh](pull.sh): If no changes in repo, checkouts to master and pulls changes. Otherwise it lists changes
- [rebase.sh](rebase.sh): The same as pull.sh, then rebases your current branch
- [list-branches.sh](list-branches.sh): Prints local branches, current with `*`
- [list-changes.sh](list-changes.sh): Prints changes in repo 
- [cleanup.sh](cleanup.sh): Deletes branches merged to master 
  - Without args: local branches only
  - With `--with-remote` arg: also deletes merged remote branches

For loop over all repositories, use:

- [git-mass.sh <operation>](git-mass.sh)
  - git-mass.sh pull
  - git-mass.sh rebase
  - git-mass.sh list-branches
  - git-mass.sh list-changes
  - git-mass.sh cleanup [--with-remote]
  