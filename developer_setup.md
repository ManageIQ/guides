# New Developer Setup

### Requirements Summary

| **Name**   | **Version** |
| ---------- | ----------- |
| Ruby       | 2.5.x       |
| Rails      | 5.1.x       |
| Bundler    | 1.15.x      |
| NodeJS     | 12.x.x      |
| Python     | 2.7.x       |
| PostgresQL | 10.x        |

## Build Requirements

If running CentOS 8:
```
sudo yum config-manager --set-enabled PowerTools
sudo dnf copr enable manageiq/ManageIQ-Master
sudo yum install epel-release
```

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

#### Configure the cluster

On Fedora and CentOS, configure a cluster using `postgresql-setup`.

```bash
sudo PGSETUP_INITDB_OPTIONS='--auth trust --username root --encoding UTF-8 --locale C' postgresql-setup --initdb
```

On Debian and Ubuntu, configure a cluster using `pg_createcluster`.

```bash
sudo pg_dropcluster --stop 10 main
sudo pg_createcluster -e UTF-8 -l C 10 main -- --auth trust --username root
sudo pg_ctlcluster 10 main start
```

On macOS, configure a cluster using `initdb` directly.

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

Yarn and NodeJS version 10 or newer are required. If your distribution doesn't ship NodeJS 10.x, you can install [nvm](https://github.com/nvm-sh/nvm) and follow the setup steps (you will need to restart your shell in order to source the nvm initialization environment).

```bash
nvm install 10
```

Then install `yarn` - you can find the recommended way for your platform at https://classic.yarnpkg.com/en/docs/install, or, if that fails, via npm.

```bash
npm install -g yarn
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

## Configure Project

A Ruby script called `setup` is available to quickly set up the application. This script installs the required Gems, sets up necessary JavaScript libraries, creates and migrates the database, and finally seeds the database with initial content.

---
**NOTE**

macOS requires platform specific Gems. Run `bundle config specific_platform true` before running `setup`.

CentOS 7 requires the `rh-postgresql10` SCL environment in order to compile the `pq` Gem's native extensions. Run `setup` inside the `scl` environment: `scl enable rh-postgresql10 'bin/setup'`.

If you've run PostgreSQL in a container, be sure to export the `DATABASE_URL` variable to connect to the container over TCP instead of a UNIX file socket.

```bash
export DATABASE_URL='postgresql://localhost:5432' # optional, only necessary if PostgreSQL is running in a container
```

---

```bash
bin/setup
```

## Start the Application

```bash
bundle exec rails evm:start
```

The web UI should now be available at `http://localhost:3000`. The default username is `admin` and the default password is `smartvm`.

## Further Reading

* [Individual workers](developer_setup/foreman.md) can be started using [Foreman](https://ddollar.github.io/foreman) directly.
* [Running the test suites](developer_setup/running_test_suites.md)
* [Provider, UI and plugin development](developer_setup/plugins.md) describes the plugin and external provider development process.
* [Git workflow](developer_setup/git_workflow.md) outlines the recommended `git` and GitHub options.
