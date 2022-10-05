# New Developer Setup

### Requirements Summary

| **Name**   | **Min Version** | **Max Version** |
| ---------- | --------------- | --------------- |
| Ruby       | 2.7.x           | 3.0.x           |
| Bundler    | 2.1.4           | 2.x             |
| NodeJS     | 14.x.x          |                 |
| Python     | 3.8.x           |                 |
| PostgreSQL | 10.x            | 12.x            |

## Prerequisites

### System packages

1. Only if running CentOS 8

   ```bash
   sudo yum config-manager --set-enabled PowerTools
   sudo dnf copr enable manageiq/ManageIQ-Master
   sudo yum install epel-release
   ```

2. In order to compile Ruby, install the header files for OpenSSL, readline and zlib.

   |      |     |
   | ---- | --- |
   | dnf  | `sudo dnf -y install openssl-devel readline-devel zlib-devel` |
   | yum  | `sudo yum -y install openssl-devel readline-devel zlib-devel` |
   | apt  | `sudo apt -y install libssl-dev libreadline-dev zlib1g-dev` |
   | brew | `brew install openssl` |

3. In addition, in order to compile Ruby, native Gems and native NodeJS modules, other libraries are required.

   |      |     |
   | ---- | --- |
   | dnf  | `sudo dnf -y install @c-development libffi-devel postgresql-devel libxml2-devel libcurl-devel cmake python libssh2-devel` |
   | yum  | `sudo yum -y install @development libffi-devel postgresql-devel libxml2-devel libcurl-devel cmake python libssh2-devel` |
   | apt  | `sudo apt -y install build-essential libffi-dev libpq-dev libxml2-dev libcurl4-openssl-dev cmake python libssh2-1-dev` |
   | brew | `brew install cmake libssh2` |

### Services

ManageIQ requires a memcached instance for session caching and a PostgreSQL database for persistent data storage.

#### memcached

1. Install

   |            |     |
   | ---------- | --- |
   | dnf        | `sudo dnf -y install memcached` |
   | yum        | `sudo yum -y install memcached` |
   | apt        | `sudo apt -y install memcached` |
   | brew       | `brew install memcached` |
   | containers | N/A |

2. Start the service

   |            |     |
   | ---------- | --- |
   | systemd    | `systemctl enable --now memcached` |
   | brew       | `brew services start memcached` |
   | containers | `podman run --detach --publish 11211:11211 memcached` |

#### PostgreSQL

1. Install

   |            |     |
   | ---------- | --- |
   | dnf        | `sudo dnf -y install postgresql-server` |
   | yum        | `sudo yum -y install postgresql-server` |
   | apt        | `sudo apt -y install postgresql-11` |
   | brew       | `brew install postgresql@11` |
   | containers | N/A |

2. Configure and start the cluster

   * Fedora / CentOS

     ```bash
     sudo PGSETUP_INITDB_OPTIONS='--auth trust --username root --encoding UTF-8 --locale C' postgresql-setup --initdb
     ```

   * Debian / Ubuntu

     ```bash
     sudo pg_dropcluster --stop 11 main
     sudo pg_createcluster -e UTF-8 -l C 11 main -- --auth trust --username root
     sudo pg_ctlcluster 11 main start
     ```

   * macOS

     `brew` will configure the cluster automatically, but you will need to create the user.

     ```bash
     brew services start postgresql@11
     psql -c "CREATE USER root SUPERUSER PASSWORD 'smartvm';" -U $USER -d template1
     ```

     If not using brew, you can configure a cluster using `initdb` directly.

     ```bash
     rm -rf /usr/local/var/postgres
     initdb --auth trust --username root --encoding UTF-8 --locale C /usr/local/var/postgres
     ```

   * containers

     Skip ahead to "Start the service"

2. Start the service

   |            |     |
   | ---------- | --- |
   | systemd    | `systemctl enable --now postgresql` |
   | brew       | *Already started above |
   | containers | `podman run --detach --publish 5432:5432 --env POSTGRES_USER=root postgres` |

### nvm and JavaScript build utilities

[nvm](https://github.com/nvm-sh/nvm) is *strongly* recommended for NodeJS version management.

```bash
nvm install 14
nvm use 14

# Set version 14 as the default for all scripts
nvm alias default 14
```

You may need to restart your shell in order to source the nvm initialization environment.

Then install `yarn` - you can find the recommended way for your platform at https://classic.yarnpkg.com/en/docs/install, or, if that fails, via npm.

```bash
npm install --global yarn
```

### Ruby and Bundler

A Ruby version manager is *strongly* recommended. Use any one of the following:

* [chruby](https://github.com/postmodern/chruby) + [ruby-install](https://github.com/postmodern/ruby-install)
* [rbenv](https://github.com/rbenv/rbenv) + [ruby-build](https://github.com/rbenv/ruby-build#readme)
* [rvm](http://rvm.io/)

Using the Ruby version manager, install `ruby` >= 2.7.0 and < 3.1.0 and the latest `bundler`.

---

## Clone ManageIQ

You must first fork the repository, clone it and then create an upstream remote. Additionally, to run the following commands you will need to setup an SSH key. Detailed instructions on how to do (as well as set up the recommended git and GitHub options) can be found in [Git workflow](developer_setup/git_workflow.md).

```bash
git clone git@github.com:<username>/manageiq.git
cd manageiq
git remote add upstream git@github.com:ManageIQ/manageiq.git
git fetch upstream
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
* [ManageIQ Bot](https://github.com/ManageIQ/miq_bot#manageiq-bot) a bot to automate various developer problems such as commit monitoring, Github pull request and Travis monitoring.
