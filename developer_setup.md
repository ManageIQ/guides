# New Developer Setup

### Requirements Summary

| **Name**   | **Version** |
| ---------- | ----------- |
| Ruby       | 2.4.x       |
| Rails      | 5.1.x       |
| Bundler    | 1.15.x      |
| NodeJS     | 10.16.x     |
| Python     | 2.7.x       |
| PostgresQL | 10.x        |

## Build Requirements

In order to compile Ruby, native Gems and native NodeJS modules, GCC and its related utilities are required. Depending on your Linux distribution, package names may vary slightly.

* Using dnf: `sudo dnf -y install @c-development libffi-devel postgresql-devel libxml2-devel libcurl-devel cmake sqlite-devel python`
* Using yum: `sudo yum -y install @development libffi-devel postgresql-devel libxml2-devel libcurl-devel cmake sqlite-devel python`
* Using apt: `sudo apt -y install build-essential libffi-dev libpq-dev libxml2-dev libcurl4-openssl-dev cmake libsqlite3-dev python`
* Using brew: `brew install cmake`

To ensure the appropriate extensions are built when Ruby is compiled, install the header files for OpenSSL, readline and zlib.

* Using dnf: `sudo dnf -y install openssl-devel readline-devel zlib-devel`
* Using yum: `sudo yum -y install openssl-devel readline-devel zlib-devel`
* Using apt: `sudo apt -y install libssl-dev libreadline-dev zlib1g-dev`
* Using brew: `brew install openssl`

## Service Requirements

ManageIQ requires a memcached instance for session caching and a PostgreSQL database for persistent data storage.

### Containers

Run memcached, exposing port 11211 to the host:

```bash
podman run --detach --publish 11211:11211 memcached
```

Run PostgreSQL, exposing port 5432 to the host:

```bash
podman run --detach --publish 5432:5432 --env POSTGRES_USER=root postgres
```

### Locally

Install memcached:

* Using dnf: `sudo dnf -y install memcached`
* Using yum: `sudo yum -y install memcached`
* Using apt: `sudo apt -y install memcached`
* Using brew: `brew install memcached`

Enable and start the service.

Using systemd:

```bash
systemctl enable --now memcached
```

Using Homebrew:

```bash
brew services start memcached
```

Install postgresql:

* Using dnf: `sudo dnf -y install postgresql-server`
* Using yum: `sudo yum -y install postgresql-server`
* Using apt: `sudo apt -y install postgresql`
* Using brew: `brew install postgresql`

---
**NOTE**

CentOS 7 ships PostgreSQL 9.x. In order to use PostgreSQL 10.x, you will need to [enable Software Collections](https://www.softwarecollections.org/en/docs/) and install `rh-postgresql10`.

```bash
sudo yum -y autoremove postgresql-devel
sudo yum -y install rh-postgresql10 rh-postgresql10-postgresql-syspaths rh-postgresql10-postgresql-devel rh-postgresql10-postgresql-server-syspaths
```

---

Configure the cluster.

On Fedora and CentOS, configure a cluster using `postgresql-setup`.

```bash
sudo PGSETUP_INITDB_OPTIONS='--auth trust --username root --encoding UTF-8 --locale C' postgresql-setup --initdb
```

On Debian and Ubuntu, configure a cluster using `pg_createcluster`.

```bash
sudo pg_dropcluster --stop 10 main
sudo pg_createcluster -e UTF-8 -l C 10 main -- --auth trust --username root
```

On macOS, configured a cluster using `initdb` directly.

```bash
rm -rf /usr/local/var/postgres
initdb --auth trust --username root --encoding UTF-8 --locale C /usr/local/var/postgres
```

Enable and start the service.

Using systemd:

```bash
systemctl enable --now postgresql
```

Using Homebrew:

```bash
brew services start postgresql
```

## Install nvm and JavaScript build utilities

Yarn, Gulp and Webpack are required to compile JavaScript assets. NodeJS version 10.16.x is required. If your distribution doesn't ship NodeJS 10.x, you can install [nvm](https://github.com/nvm-sh/nvm) and follow the setup steps. Then install `yarn`, `gulp-cli` and `webpack`.

```bash
nvm install 10
npm install -g yarn gulp-cli webpack
```

## Install Ruby and Bundler

A Ruby version manager is *strongly* recommended. Use any one of the following:

* [rbenv](https://github.com/rbenv/rbenv)
* [rvm](http://rvm.io/)
* [chruby](https://github.com/postmodern/chruby)

Using the Ruby version manager, install `ruby` >= 2.4.0 and < 2.6.0 and `bundler` >= 1.16.

## Clone the project

```bash
git clone git@github.com:ManageIQ/manageiq.git
cd manageiq
```

## Configure Project Manually

All the steps below are wrapped inside the `bin/setup` script, but they are outlined here to explain how to completely bootstrap a developer environment. If you've run PostgreSQL in a container, be sure to export the `DATABASE_URL` variable to connect to the container over TCP instead of a UNIX file socket.

```bash
export DATABASE_URL='posgresql://localhost:5432' # optional, only necessary if PostgreSQL is running in a container
```

### Create neccessary config files

In order to run the application locally, a few sample config files need to be copied into their appropriate locations.

```bash
[[ -f "certs/v2_key" ]] || cp "certs/v2_key.dev" "certs/v2_key"
[[ -f "config/cable.yml" ]] || cp "config/cable.yml.sample" "config/cable.yml"
[[ -f "config/database.yml" ]] || cp "config/database.pg.yml" "config/database.yml"
mkdir -p log
```

### Install Bundler and Gems

---
**NOTE**

macOS requires platform specific Gems. Run `bundle config specific_platform true` before installing.

CentOS 7 requires the `rh-postgresql10` SCL environment in order to compile the `pq` Gem's native extensions. Run `bundle install` inside the `scl` environment: `scl enable rh-postgresql10 'bundle install'`.

---

```bash
gem install bundler --version 1.16 --conservative
bundle config specific_platform true # optional for non-macOS platforms
bundle install
bundle exec rails update:ui
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails test:vmdb:setup
bundle exec rails log:clear tmp:clear
```

## Configure Project Automatically

```bash
bin/setup
```

## Start the Application

```bash
bundle exec rails evm:start
```

The web UI should now be available at `http://localhost:3000`. The default username is `admin` and the default password is `smartvm`.

## Further Reading

* [Minimal Mode](developer_setup/minimal_mode.md) starts the application with fewer services and workers for faster startup or targeted end-user testing.
* [Individual workers](developer_setup/foreman.md) can be started using [Foreman](https://ddollar.github.io/foreman) directly.
* [Running the test suites](developer_setup/running_test_suites.md)
* [Provider, UI and plugin development](developer_setup/plugins.md) describes the plugin and external provider development process.
* [Git workflow](developer_setup/git_workflow.md) outlines the recommended `git` and GitHub options.
