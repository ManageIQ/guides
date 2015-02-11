## Install Packages

### Fedora 20

  1.  Install packages

      ```bash
      sudo yum -y install xchat                              # For IRC
      sudo yum -y install adobe-source-code-pro-fonts        # Nicer fonts to work with
      sudo yum -y install git-all                            # Git and components
      sudo yum -y install memcached                          # Memcached for the session store
      sudo yum -y install postgresql-devel postgresql-server # PostgreSQL Database server and to build 'pg' Gem
      sudo yum -y install libxml2-devel libxslt-devel        # For Nokogiri Gem
      sudo yum -y install gcc-c++                            # For event-machine Gem
      ```

  2.  Enable Memcached

      ```bash
      sudo systemctl enable memcached
      sudo systemctl start memcached
      ```

  3.  Configure PostgreSQL

      ```bash
      sudo passwd postgres <new_password>
      su postgres -c 'initdb -D /var/lib/pgsql/data'
      sudo systemctl enable postgresql
      sudo systemctl start postgresql
      su postgres
      psql -c "CREATE USER evm SUPERUSER PASSWORD 'YourNewPassword'"
      exit
      ```

### Mac
  1. Install PostgreSQL
    - Download and install the .dmg for 9.2.4 for MacOSX:  http://www.enterprisedb.com/products-services-training/pgdownload#osx
    - Open the dmg and run the installer (It will update your shared memory settings and prompt for a reboot, reboot it)
    - Open the dmg and run the installer again after the reboot.
    - Don't install the "stack builder" addon at the end of the PostgreSQL installation.
    - sudo modify your /etc/profile and add the following:
      ```bash
      export DYLD_LIBRARY_PATH=/Library/PostgreSQL/9.2/lib/postgresql:$DYLD_LIBRARY_PATH
      export PATH=/Library/PostgreSQL/9.2/bin:$PATH
      ```
    - Restart your terminal, and do the following:
      ```bash
      sudo chown postgres /Library/PostgreSQL/9.2/data/
      sudo -u postgres initdb -D /Library/PostgreSQL/9.2/data
      psql --version (should be the version you downloaded)
      ```

  2. Install Navicat
    - Install Navicat Premium Essentials:  http://www.navicat.com/en/download/download.html
    - Select Navicat Premium, and download Navicat Premium Essentials
    - Get a license key
    - Add a PostgreSQL connection in Navicat to localhost with the postgres user
    - Create the root user
      - Open localhost, and click Role.
      - Right-click postgres and choose Duplicate User
      - Set Role name to root and the password to smartvm
      - Click save, and although you will get an error, it will be created correctly.
      - Close the window, and when prompted click "Don't Save"
      - Right-click localhost and choose Close Connection-
      - Right-click localhost and choose Connection Properties
      - Change the User Name to root, and the password to smartvm


#### Setup Git and Github

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

  ```zsh
  git config --global user.name "Joe Smith"
  git config --global user.email joe.smith@example.com
  git config --global --bool pull.rebase true
  git config --global push.default simple
  ```
  If you need to use git with other email addresses, you can set the local user.email from within the clone using:

  ```zsh
  git config user.name "Joe Smith"
  git config user.email joe.smith@example.com
  ```

#### Install Ruby

* chruby: <https://github.com/postmodern/chruby>
* RVM: <http://rvm.io/>

#### Clone the Code

```zsh
git clone git@github.com:JoeSmith/manageiq.git # Use "-o my_fork" if you don't want the remote to be named origin
cd manageiq
git remote add upstream git@github.com:ManageIQ/manageiq.git
git fetch upstream
```

You can add other remotes at any time to collaborate with others by running:

```zsh
git remote add other_user git@github.com:OtherUser/manageiq.git
git fetch upstream
```


#### Get the Rails environment up and running

```zsh
gem install bundler -v "~>1.3"
cd vmdb
bundle install --without qpid
cd ..
rake build:shared_objects
cd vmdb
cp config/database.pg.yml config/database.yml
```

* Edit config/database.yml changing the user "root" to "evm" (the postgres role created above)
* Navigate back to the vmdb directory and run `rake evm:db:reset`
* Note: First startup should be full server start to allow DB seeding `rake evm:start`
