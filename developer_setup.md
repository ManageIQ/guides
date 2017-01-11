## Developer Setup

### Install System Packages

#### Fedora / CentOS 7

* CentOS only - Enable EPEL & install DNF

  ```bash
  sudo rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo yum -y install dnf
  ```

* Install packages

  ```bash
  sudo dnf -y install git-all                            # Git and components
  sudo dnf -y install memcached                          # Memcached for the session store
  sudo dnf -y install postgresql-devel postgresql-server # PostgreSQL Database server and to build 'pg' Gem
  sudo dnf -y install bzip2 libffi-devel readline-devel  # For rbenv install 2.2.0 (might not be needed with other Ruby setups)
  sudo dnf -y install libxml2-devel libxslt-devel patch  # For Nokogiri Gem
  sudo dnf -y install sqlite-devel                       # For sqlite3 Gem
  sudo dnf -y install nodejs                             # For ExecJS Gem and bower
  sudo dnf -y install gcc-c++                            # For unf gem
  sudo dnf -y install libcurl-devel                      # For Curb
  rpm -q --whatprovides npm || sudo dnf -y install npm   # For CentOS 7, Fedora 23 and older
  sudo dnf -y install openssl-devel                      # For rubygems
  sudo dnf -y install cmake                              # For rugged Gem
  ```

* Install the _Bower_ package manager

  ```
  sudo npm install -g bower
  ```

* Enable Memcached

  ```bash
  sudo systemctl enable memcached
  sudo systemctl start memcached
  ```

* Configure PostgreSQL
  * Required PostgreSQL version is 9.4+.
    * See [here](developer_setup/postgresql_software_collection.md) how to install
      it in Linux distributions like CentOS 7, using _SoftwareCollections.org_.
    * Or follow the directions [here](https://www.postgresql.org/download/linux/redhat/#yum)
      to install it from the PostgreSQL Global Development Group repositories.

  ```bash
  sudo postgresql-setup initdb
  sudo grep -q '^local\s' /var/lib/pgsql/data/pg_hba.conf || echo "local all all trust" | sudo tee -a /var/lib/pgsql/data/pg_hba.conf
  sudo sed -i.bak 's/\(^local\s*\w*\s*\w*\s*\)\(peer$\)/\1trust/' /var/lib/pgsql/data/pg_hba.conf
  sudo systemctl enable postgresql
  sudo systemctl start postgresql
  sudo -u postgres psql -c "CREATE ROLE root SUPERUSER LOGIN PASSWORD 'smartvm'"
  # This command can return with a "could not change directory to" error, but you can ignore it
  ```

#### Mac

* Install [Homebrew](http://brew.sh/)

  If you do not have Homebrew installed, go to the Homebrew website and install it.

* Install Packages

  ```bash
  brew install git
  brew install memcached
  brew install postgresql
  brew install cmake
  brew install node
  ```

* Install the _Bower_ package manager

  ```
  npm install -g bower
  ```

* Configure and start PostgreSQL
  * Required PostgreSQL version is 9.4+

  ```bash
  # Enable PostgreSQL on boot
  mkdir -p ~/Library/LaunchAgents
  ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
  # Create the ManageIQ superuser
  psql -d postgres -c "CREATE ROLE root SUPERUSER LOGIN PASSWORD 'smartvm'"
  ```

* Start memcached

  ```bash
  # Enable Memcached on boot
  ln -sfv /usr/local/opt/memcached/homebrew.mxcl.memcached.plist ~/Library/LaunchAgents
  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist
  ```

### Install Ruby and Bundler

* Use a Ruby version manager
  * [chruby](https://github.com/postmodern/chruby) and [ruby-install](https://github.com/postmodern/ruby-install)
  * [rvm](http://rvm.io/)
  * [rbenv](https://github.com/sstephenson/rbenv)
* Required Ruby version is 2.2.2+
* With Ruby installed, `gem install bundler` to install the latest Bundler. Required Bundler version is 1.8.7+

### Setup Git and Github

* The most reliable authentication mechanism for git uses SSH keys.
  * [SSH Key Setup](https://help.github.com/articles/generating-ssh-keys) Set up a SSH keypair for authentication.  Note: If you enter a passphrase, you will be prompted every time you authenticate with it.
* Github account setup [Account Settings](https://github.com/settings).
  * [Profile](https://github.com/settings/profile): Fill in your personal information, such as your name.
  * [Profile](https://github.com/settings/profile): Optionally set up an avatar at gravatar.com.  When you set up your gravatar, be sure to have an entry for the addresses you plan to use with git / Github.
  * [Emails](https://github.com/settings/emails): Enter your e-mail address and verify it, click the Verify button and follow the instructions.
  * [Notification Center](https://github.com/settings/notifications) / Notification Email / Custom Routing: Change the email address associated with ManageIQ if desired.
  * If you are a member of the ManageIQ organization:
    * Go to [the Members page](https://github.com/ManageIQ?tab=members).
      * Verify you are listed.
      * Optionally click Publicize Membership.
* Fork ManageIQ/manageiq:
  * Go to [ManageIQ/manageiq](https://github.com/ManageIQ/manageiq)
  * Click the Fork button and choose "Fork to \<yourname\>"
* Git configuration and default settings.

  ```bash
  git config --global user.name "Joe Smith"
  git config --global user.email joe.smith@example.com
  git config --global --bool pull.rebase true
  git config --global push.default simple
  ```

  If you need to use git with other email addresses, you can set the local user.email from within the clone using:

  ```bash
  git config user.name "Joe Smith"
  git config user.email joe.smith@example.com
  ```

### Clone the Code

```bash
git clone git@github.com:JoeSmith/manageiq.git # Use "-o my_fork" if you don't want the remote to be named origin
cd manageiq
git remote add upstream git@github.com:ManageIQ/manageiq.git
git fetch upstream
```

You can add other remotes at any time to collaborate with others by running:

```bash
git remote add other_user git@github.com:OtherUser/manageiq.git
git fetch other_user
```

### Clone some plugins

If you want to do ManageIQ plugin development, you clone plugins locally. E.g.

```bash
cd manageiq ; mkdir plugins
git clone git@github.com:JoeSmith/manageiq-providers-amazon.git plugins/manageiq-providers-amazon
git clone git@github.com:JoeSmith/manageiq-content.git plugins/manageiq-content
git clone git@github.com:JoeSmith/manageiq-ui-classic.git plugins/manageiq-ui-classic
```

In your local Gemfile.dev.rb in your ManageIQ checkout add:

```bash
override_gem 'manageiq-providers-amazon', :path => File.expand_path('plugins/manageiq-providers-amazon', __dir__)
override_gem 'manageiq-content', :path => File.expand_path('plugins/manageiq-providers-amazon', __dir__)
override_gem 'manageiq-ui-classic', :path => File.expand_path('plugins/manageiq-ui-classic', __dir__)
```

In your plugin, just use `bin/setup` and `bin/update` as usual. This will checkout a shallow copy of ManageIQ as a
dummy app to run the test.

```bash
cd plugins/manageiq-providers-amazon
bin/setup
# == Cloning manageiq sample app ==
# Cloning into 'spec/manageiq'...
bin/update
# == Updating manageiq sample app ==
```

Alternatively you can symlink `spec/manageiq` to your local ManageIQ clone, which will allow you to run tests against
a local manageiq feature branch.

```bash
cd plugins/manageiq-providers-amazon
ln -s ~/src/manageiq spec/manageiq
bin/update
# == SKIPPING update of spec/manageiq because its symlinked ==
```

### Get the Rails environment up and running

```bash
bin/setup                  # Installs dependencies, config, prepares database, etc
bundle exec rake evm:start # Starts the ManageIQ EVM Application in the background
```

* You can now access the application at `http://localhost:3000`. The default username is `admin` with password `smartvm`.
* There is also a minimal mode available to start the application with fewer services and workers for faster startup or
targeted end-user testing. See the [minimal mode guide](developer_setup/minimal_mode.md) for details.
* To run the test suites, see [the guide on that topic](developer_setup/running_test_suites.md).

### Update dependencies and migrate db

* You can update ruby and javascript dependencies as well as run migrations using one command

```bash
bin/update                # Updates dependencies using bundler and bower, runs migrations, prepares test db.
```

#### Some troubleshooting notes

* First login fails

Make sure you have memcached running. If not stop the server with `bundle exec rake evm:stop`,
start memcached and retry.

* `bin/setup fails` while trying to load the gem 'sprockets/es6'

If this happens check the log for
`ExecJS::RuntimeUnavailable: Could not find a JavaScript runtime` a few lines down.
When this message is present, then the you need to install `node.js` and re-try

* `bin/setup` fails while trying to install the 'nokogiri' gem

If this happens, you may be missing developer tools in your OS X. Try to install them with
`xcode-select --install` and re-try.
