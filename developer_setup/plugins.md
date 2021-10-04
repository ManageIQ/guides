## ManageIQ Plugin Development

### Plugin layout

Plugins in ManageIQ are developed as [Rails Engines](http://guides.rubyonrails.org/engines.html). All models, 
controllers etc. are loaded during boot time of ManageIQ and are just available as you would expect.

### Cloning plugins

Before anything, you have to create a fork of the plugin on Github. 

* Go to the plugins repository page, e.g. [ManageIQ/manageiq-ui-classic](https://github.com/ManageIQ/manageiq-ui-classic)
* Click the Fork button and choose "Fork to \<yourname\>"

It does not really matter _where_ you clone your plugins. Both approaches have their advantages.

#### Side by side

Having the plugins and the core repository side by side, i.e. at the same directory level, is straight forward and
lets you separate checkouts cleanly.

```bash
git clone git@github.com:JoeSmith/manageiq-providers-amazon.git
git clone git@github.com:JoeSmith/manageiq-content.git
git clone git@github.com:JoeSmith/manageiq-ui-classic.git
```

#### Inside the core ManageIQ checkout

The `plugins/` directory inside the core repository is ignored by `.gitignore`. This means you can clone plugins
into this directory. The benefit is, e.g. when working with a project oriented IDE, you have all code under one
directory. This way you can easily search across the core _and_ plugin code base. 

You still have to change into the plugin root directory to run the tests - running `rspec` from the ManageIQ root will
not pickup your plugin code, but the core code. This is a drawback which can lead to some confusion.

```bash
cd /path/to/manageiq ; mkdir plugins
git clone git@github.com:JoeSmith/manageiq-providers-amazon.git plugins/manageiq-providers-amazon
git clone git@github.com:JoeSmith/manageiq-content.git plugins/manageiq-content
git clone git@github.com:JoeSmith/manageiq-ui-classic.git plugins/manageiq-ui-classic
```

#### Setting the correct remotes

Inside your checkout you will have the default remote origin pointing to your fork. Now add an upstream remote which
points to the upstream repository. To keep your fork up to date, you will have to merge changes from upstream
into your fork.

```bash
cd manageiq-ui-classic
git remote -v
# origin  git@github.com:JoeSmith/manageiq-ui-classic.git (fetch)
# origin  git@github.com:JoeSmith/manageiq-ui-classic.git (push)
git remote add upstream git@github.com:ManageIQ/manageiq-ui-classic
git fetch upstream
# merge upstream into your fork
git checkout master
git pull upstream master
git push origin master
```

### Running tests

To run the tests for a plugin, we need an application context. Usually Rails expects a dummy Rails app. But because
our plugins are only for ManageIQ, we run the tests inside the ManageIQ app. Therefore we need a checkout of ManageIQ
at `spec/manageiq`. The database used for tests is the same as for the core app. Keep that in mind when developing a
feature that requires database migrations.

```bash
cd manageiq-providers-amazon
bin/setup
# == Cloning manageiq sample app ==
# Cloning into 'spec/manageiq'...
bundle install
bundle exec rake spec:setup
# ** Preparing database
# Dropped database 'vmdb_test'
# Created database 'vmdb_test'
bundle exec rake
```

Updating the sample app is handled by `bin/update`:

```bash
bin/update
# == Updating manageiq sample app ==
```

### Cross repository dependencies

Sometimes you need to develop your feature against a branch of ManageIQ that is not yet merged into master. This creates
cross repository dependencies, which can be handled from the plugin side or from the core side.

#### Symlink your sample app

Creating a symlink from `spec/manageiq` to your current checkout of ManageIQ will run the tests inside whatever branch
you checked out in the core repo.

```bash
# remove current sample app
rm -rf spec/manageiq 
# create a symlink
ln -s /path/to/manageiq spec/manageiq
```

#### Dependency on a local gem

Inside ManageIQ core, you can override gem dependencies with `override_gem`. This is a small helper to be used under
`bundler.d` directory. Use it to point the dependency to a local version of your plugin. 

Please, use absolute path in
```ruby
# bundler.d/local_plugins.rb:
override_gem 'manageiq-providers-amazon', :path => File.expand_path('/home/developer/repos/manageiq-providers-amazon')
```

or use relative path to current file and `__dir__` like
```ruby
# bundler.d/local_plugins.rb:
override_gem 'manageiq-providers-amazon', :path => File.expand_path('../../manageiq-providers-amazon', __dir__)
```

Once path is updated in local_plugins.rb, run bin/update and restart the server. After these changes, once you make any changes in plugin code, changes can be seen by refreshing browser.

```bash
bin/update
# == Updating manageiq sample app ==
```
 
 If you plan to change any javsacript files in plugins, please run `bin/webpack --watch --follow` in another tab in manageiq-ui-classic repo to see the reflected changes.

#### Rails console

Unfortunately Rails Engines don't support running `rails console` from the root of the plugin. To test your code you
will have to change the dependency of ManageIQ to point to your local plugin. See above.

### Creating a new provider (plugin)

If you plan to create a cloud manager type provider, you can use this [provider generator](/plugins/generator.md) to scaffold.
