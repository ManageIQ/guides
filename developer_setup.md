## Packages to Install
* Fedora 20
  ```sh
  * Install packages
  sudo yum -y install xchat                                                         # For IRC
  sudo yum -y install adobe-source-code-pro-fonts                                   # Nicer fonts to work with
  sudo yum -y install git-all                                                       # Git and components
  sudo yum -y install memcached                                                     # Memcached for the session store
  sudo yum -y install postgresql postgresql-libs postgresql-devel postgresql-server # PostgreSQL Database server and to build 'pg' Gem
  sudo yum -y install libxml2-devel libxslt-devel                                   # For Nokogiri Gem
  sudo yum -y install gcc-c++                                                       # For event-machine Gem

  * Enable Memcached
  sudo systemctl enable memcached
  sudo systemctl start memcached

  * Configure PostgreSQL
  sudo passwd postgres <new_password>
  su postgres -c 'initdb -D /var/lib/pgsql/data'
  sudo systemctl enable postgresql
  sudo systemctl start postgresql
  su postgres
  psql -c "CREATE USER evm SUPERUSER PASSWORD 'YourNewPassword'"
  exit
  ```

* Mac
  ```sh
  ```

## Git and Github Setup
* The most reliable authentication mechanism for git uses SSH keys.
  * [SSH Key Setup](https://help.github.com/articles/generating-ssh-keys) Set up a SSH keypair for authentication.  Note: If you enter a passphrase, you will be prompted every time you authenticate with it.

* Github account setup [Account Settings](https://github.com/settings).
  * [Profile](https://github.com/settings/profile): Fill in your personal information, such as your name.
  * [Profile](https://github.com/settings/profile): Optionally set up an avatar at gravatar.com.  When you set up your gravatar, be sure to have an entry for the addresses you plan to use with git / Github.
  * [Emails](https://github.com/settings/emails): Enter your e-mail address and verify it, click the Verify button and follow the instructions.
  * [Notification Center](https://github.com/settings/notifications) / Notification Email / Custom Routing: Change the email address associated with ManageIQ if desired.
* Forking ManageIQ/manageiq:
  * Go to [ManageIQ/mangeiq](https://github.com/ManageIQ/manageiq)
  * Click the Fork button and choose "Fork to \<yourname\>"

* Git configuration and default settings.
  ```sh
  git config --global user.name "Joe Smith"
  git config --global user.email joe.smith@example.com
  git config --global --bool pull.rebase true
  git config --global push.default simple
  ```
  * If you need to use git with other email addresses, you can set the local user.email from within the clone using:
    ```sh
    git config user.name "Joe Smith"
    git config user.email joe.smith@example.com
    ```

## Install ruby
  * chruby: https://github.com/postmodern/chruby
  * RVM: http://rvm.io/

## Cloning the code.
  ```sh
  git clone git@github.com:JoeSmith/manageiq.git # Use "-o my_fork" if you don't want the remote to be named origin
  cd manageiq
  git remote add upstream git@github.com:ManageIQ/manageiq.git
  git fetch upstream
  ```
  * You can add other remotes at any time to collaborate with others by running:
  ```sh
  git remote add other_user git@github.com:OtherUser/manageiq.git
  git fetch upstream
  ```


## Getting the rails environment up and running.
  ```sh
  gem install bundler -v "~>1.3"
  cd vmdb
  bundle install --without qpid
  cd ..
  rake build:shared_objects
  cd vmdb
  cp config/database.pg_dev.yml config/database.yml
  ```
  * Edit config/database.yml changing the user "root" to "evm" (the postgres role created above)
  * Navigate back to the vmdb directory and run ```rake evm:db:reset```
  * Note: First startup should be full server start to allow DB seeding ```rake evm:start```
