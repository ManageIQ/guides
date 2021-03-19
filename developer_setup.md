# New Developer Setup

### Requirements Summary

| **Name**   | **Version** |
| ---------- | ----------- |
| Ruby       | 2.6.x       |
| Rails      | 6.0.x       |
| Bundler    | 1.15.x      |
| NodeJS     | 12.x.x      |
| Python     | 2.7.x       |
| PostgreSQL | 10.x        |

## Prerequisites

If running CentOS 8

```bash
sudo yum config-manager --set-enabled PowerTools
sudo dnf copr enable manageiq/ManageIQ-Master
sudo yum install epel-release
```

In order to compile Ruby, install the header files for OpenSSL, readline and zlib.

|      |     |
| ---- | --- |
| dnf  | `sudo dnf -y install openssl-devel readline-devel zlib-devel` |
| yum  | `sudo yum -y install openssl-devel readline-devel zlib-devel` |
| apt  | `sudo apt -y install libssl-dev libreadline-dev zlib1g-dev` |
| brew | `brew install openssl` |


In order to compile Ruby, native Gems and native NodeJS modules, other libraries are required.

|      |     |
| ---- | --- |
| dnf  | `sudo dnf -y install @c-development libffi-devel postgresql-devel libxml2-devel libcurl-devel cmake python` |
| yum  | `sudo yum -y install @development libffi-devel postgresql-devel libxml2-devel libcurl-devel cmake python` |
| apt  | `sudo apt -y install build-essential libffi-dev libpq-dev libxml2-dev libcurl4-openssl-dev cmake python` |
| brew | `brew install cmake` |

### Prerequisite services

ManageIQ requires a memcached instance for session caching and a PostgreSQL database for persistent data storage.

#### memcached

##### Install

|            |     |
| ---------- | --- |
| dnf        | `sudo dnf -y install memcached` |
| yum        | `sudo yum -y install memcached` |
| apt        | `sudo apt -y install memcached` |
| brew       | `brew install memcached` |
| containers | N/A |

##### Start the service

|            |     |
| ---------- | --- |
| systemd    | `systemctl enable --now memcached` |
| brew       | `brew services start memcached` |
| containers | `podman run --detach --publish 11211:11211 memcached` |

#### PostgreSQL

##### Install

|            |     |
| ---------- | --- |
| dnf        | `sudo dnf -y install postgresql-server` |
| yum        | `sudo yum -y install postgresql-server` |
| apt        | `sudo apt -y install postgresql` |
| brew       | `brew install postgresql` |
| containers | N/A |

###### NOTE

CentOS 7 ships PostgreSQL 9.x. In order to use PostgreSQL 10.x, you will need to [enable Software Collections](https://www.softwarecollections.org/en/docs/) and install `rh-postgresql10`.

```bash
sudo yum -y autoremove postgresql-devel
sudo yum -y install rh-postgresql10 rh-postgresql10-postgresql-syspaths rh-postgresql10-postgresql-devel rh-postgresql10-postgresql-server-syspaths
```

CentOS 7 requires the `rh-postgresql10` SCL environment in order to compile the `pq` gem's native extensions. Run `bin/setup` inside the `scl` environment: `scl enable rh-postgresql10 'bin/setup'`.

##### Configure the cluster

* Fedora / CentOS

  ```bash
  sudo PGSETUP_INITDB_OPTIONS='--auth trust --username root --encoding UTF-8 --locale C' postgresql-setup --initdb
  ```

* Debian / Ubuntu

  ```bash
  sudo pg_dropcluster --stop 10 main
  sudo pg_createcluster -e UTF-8 -l C 10 main -- --auth trust --username root
  sudo pg_ctlcluster 10 main start
  ```

* macOS

  `brew` will configure the cluster automatically.

  If not using brew, you can configure a cluster using `initdb` directly.

  ```bash
  rm -rf /usr/local/var/postgres
  initdb --auth trust --username root --encoding UTF-8 --locale C /usr/local/var/postgres
  ```

* containers

  Skip ahead to "Start the service"

##### Start the service

|            |     |
| ---------- | --- |
| systemd    | `systemctl enable --now postgresql` |
| brew       | `brew services start postgresql` |
| containers | `podman run --detach --publish 5432:5432 --env POSTGRES_USER=root postgres` |

### Install nvm and JavaScript build utilities

Yarn and NodeJS version 12 or newer are required. If your distribution doesn't ship NodeJS 12.x, you can install [nvm](https://github.com/nvm-sh/nvm) and follow the setup steps (you will need to restart your shell in order to source the nvm initialization environment).

```bash
nvm install 12

# needed when other versions are installed
nvm use 12

# if the wrong version still gets used in scripts
nvm alias default 12
```

Then install `yarn` - you can find the recommended way for your platform at https://classic.yarnpkg.com/en/docs/install, or, if that fails, via npm.

```bash
npm install --global yarn
```

### Install Ruby and Bundler

A Ruby version manager is *strongly* recommended. Use any one of the following:

* [rbenv](https://github.com/rbenv/rbenv) + [ruby-build](https://github.com/rbenv/ruby-build#readme)
* [chruby](https://github.com/postmodern/chruby) + [ruby-install](https://github.com/postmodern/ruby-install)
* [rvm](http://rvm.io/)

Using the Ruby version manager, install `ruby` >= 2.6.0 and < 3.0.0 and the latest `bundler`.

---

## Clone ManageIQ

```bash
git clone git@github.com:ManageIQ/manageiq.git
cd manageiq
```

## Configure ManageIQ

A setup script is available to quickly set up the application. This script installs the required Gems, sets up necessary JavaScript libraries, creates and migrates the database, and finally seeds the database with initial content.


```bash
bin/setup
```

###### NOTE

macOS requires platform specific Gems. Run `bundle config specific_platform true` before running `bin/setup`.

If you've run PostgreSQL in a container, be sure to export the `DATABASE_URL` variable to connect to the container over TCP instead of a UNIX file socket.

```bash
export DATABASE_URL='postgresql://localhost:5432' # optional, only necessary if PostgreSQL is running in a container
```

## Start ManageIQ

```bash
bundle exec rails server
```

The web UI should now be available at `http://localhost:3000`. The default username is `admin` and the default password is `smartvm`.  If you can login, then everything is working!  Press Ctrl-C to stop the Rails server.

Note that in this runtime mode we are only verifying that the components are installed correctly.  However, individual workers are not running, so actions that require asynchronous handling will appear to hang forever.  To run the application complete with all workers, you can start with `bundle exec rails evm:start` and stop with `bundle exec rails evm:stop`.  Otherwise, read ahead to learn about running individual workers during development.

## Further Reading

* [Individual workers](developer_setup/foreman.md) can be started using [Foreman](https://ddollar.github.io/foreman) directly.
* [Running the test suites](developer_setup/running_test_suites.md)
* [Provider, UI and plugin development](developer_setup/plugins.md) describes the plugin and external provider development process.
* [Git workflow](developer_setup/git_workflow.md) outlines the recommended `git` and GitHub options.
