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
1. `echo 'gem "manageiq-ui-classic", :path => "../manageiq-ui-classic/"' >> Gemfile.dev.rb`
1. `bin/update`

And you should be set :).


### Migrating a PR from the old repo

(coming soon)
