## Updating the devel setup to work with the split UI repo

We've split the UI from the main repo, so now, `ManageIQ/manageiq` doesn't have a UI.

If you're not doing any UI work, it should still work out of the box (`manageiq` depends on `manageiq-ui-classic` as a gem by default) and you don't have to do anything.

But if you do..


### Setting up the repo

1. Fork [ManageIQ/manageiq-ui-classic](https://github.com/ManageIQ/manageiq-ui-classic)
1. Be in the directory that contains your `manageiq/` (**not** *in* your `manageiq/`) - so that the two repos are cloned side by side
1. `git clone git@github.com:YOU/manageiq-ui-classic`
1. `cd manageiq-ui-classic`
1. `git remote add upstream git@github.com:ManageIQ/manageiq-ui-classic.git`
1. `ln -s ../../manageiq spec/`
1. `cd ../manageiq`
1. `echo "override_gem 'manageiq-ui-classic', :path => File.expand_path('../manageiq-ui-classic', __dir__)" >> Gemfile.dev.rb`
1. `bin/update`

And you should be set :).

### Migrating a PR from the old repo

Needs `jq` to parse the github API output - `brew install jq` or `dnf install jq` or `apt install jq`.

Optionally uses [hub](https://hub.github.com/) to create the pull request.


```
PR=123
COMMITS=`wget -qO- https://api.github.com/repos/ManageIQ/manageiq/pulls/$PR/commits | jq -r .[].sha`
TITLE=`wget -qO- https://api.github.com/repos/ManageIQ/manageiq/pulls/$PR | jq -r .title`
DESCRIPTION=`wget -qO- https://api.github.com/repos/ManageIQ/manageiq/pulls/$PR | jq -r .body`

cd manageiq-ui-classic/

git remote add tmp https://github.com/ManageIQ/manageiq.git

git fetch tmp pull/$PR/head
git checkout -b miq_pr_$PR

echo "Running cherry-pick - if there's a conflict, resolve it, commit, and do git cherry-pick --continue"
git cherry-pick -x $COMMITS

git push -u origin miq_pr_$PR
[ -x "`which hub`" ] && hub pull-request -m "$TITLE

$DESCRIPTION

(converted from ManageIQ/manageiq#$PR)" || echo "hub not found, not creating PR"

git remote rm tmp
```
