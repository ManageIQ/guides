## GIT Helpers for ManageIQ

Following scripts iterate over core and plugins and performs useful mass operations.

### Config

[config.sh](config.sh) file contains basic settings, like your home and plugins directory of ManageIQ.  
If you want to redefine some value, create `config.dev.sh` file (excluded from git) and override variable.

### Repositories

List of repositories are either generated automatically (`$custom_repo_list == 0`) or you can define your own array manually
(`$custom_repo_list == 1`). See config for example. 

### Scripts

- [pull.sh](pull.sh): Checkouts all unchanged repos to master and pulls changes
- [rebase.sh](rebase.sh): For all unchanged repos does the same as pull.sh and then rebases your current branch
- [list-branches.sh](list-branches.sh): Prints current branches in all repos
- [list-changes.sh](list-changes.sh): Prints changes in all repos 
- [cleanup.sh](scripts/git/cleanup.sh): Deletes branches merged to master 
  - Without args: local branches only
  - With `--remote-cleanup` arg: also deletes merged remote branches
   