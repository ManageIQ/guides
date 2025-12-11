# New Developer Setup

### Requirements Summary

| **Name**   | **Min Version** | **Max Version** |
| ---------- | --------------- | --------------- |
| Ruby       | 3.3.x           | 3.4.x           |
| Bundler    | 2.5.20          | 4.x             |
| NodeJS     | 20.19.5         | 20.x.x          |
| Python     | 3.9.x           |                 |
| PostgreSQL | 13.x            | 16.x            |
| Java       | 11.x            | 19.x            |
| Kafka      | 3.3.1           |                 |

## Prerequisites

### System packages

1. In order to compile Ruby, install the header files for OpenSSL, readline and zlib.

   |      |     |
   | ---- | --- |
   | dnf  | `sudo dnf -y install openssl-devel readline-devel zlib-devel` |
   | yum  | `sudo yum -y install openssl-devel readline-devel zlib-devel` |
   | apt  | `sudo apt -y install libssl-dev libreadline-dev zlib1g-dev` |
   | brew | `brew install openssl` |

2. In addition, in order to compile Ruby, native Gems and native NodeJS modules, other libraries are required.

   |      |     |
   | ---- | --- |
   | dnf  | `sudo dnf -y install @c-development libffi-devel postgresql-devel libxml2-devel libcurl-devel cmake python libssh2-devel` |
   | yum  | `sudo yum -y install @development libffi-devel postgresql-devel libxml2-devel libcurl-devel cmake python libssh2-devel` |
   | apt  | `sudo apt -y install build-essential libffi-dev libpq-dev libxml2-dev libcurl4-openssl-dev cmake python libssh2-1-dev` |
   | brew | `brew install cmake libssh2 iproute2mac ansible` |

   On Fedora 41+  you have to also run `sudo dnf install -y openssl-devel-engine`
   On the mac, `iproute2mac` provides the `ip` command for `appliance_console`.

   **Note**: Users with MacOS running on Apple M1 CPU might need to specify location of the `Homebrew` libraries explicitly.
   If build steps below fail for you then run `export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib"`and retry the failing build step.
   See here for additional information: https://github.com/Homebrew/brew/issues/13481

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
   | apt        | `sudo apt -y install postgresql` |
   | brew       | `brew install postgresql@13` |
   | containers | N/A |

2. Configure and start the cluster

   * Fedora / CentOS

     ```bash
     sudo PGSETUP_INITDB_OPTIONS='--auth trust --username root --encoding UTF-8' postgresql-setup --initdb
     ```

   * Debian / Ubuntu

     ```bash
     pg_version=$(pg_lsclusters --no-header | awk '{print $1}' | sort -n | tail -1)
     sudo pg_dropcluster --stop $pg_version main
     sudo pg_createcluster -e UTF-8 -l C $pg_version main -- --auth trust --username root
     sudo pg_ctlcluster $pg_version main start
     ```

   * macOS

     `brew` will configure the cluster automatically, but you need to make a few tweaks
     including granting access to the root user.

     ```conf
     # ${HOMEBREW_PREFIX}/var/postgresql@13/postgresql.conf
     # right after authentication_timeout = 1min
     # More secure and closer to production. (standard on pg 14+)
     password_encryption = scram-sha-256
     # needed for multi-region replication
     wal_level = logical
     # parallel testing requires more locks per transactions
     max_locks_per_transaction = 128
     ```

     ```bash
     brew services start postgresql@13
     psql -c "CREATE USER root SUPERUSER PASSWORD 'smartvm';" -U $USER -d template1
     ```

     If not using brew, you can configure a cluster using `initdb` directly.

     ```bash
     rm -rf /usr/local/var/postgres
     initdb --auth trust --username root --encoding UTF-8 /usr/local/var/postgres
     ```

   * containers

     Skip ahead to "Start the service"

3. Start the service

   |            |     |
   | ---------- | --- |
   | systemd    | `systemctl enable --now postgresql` |
   | brew       | Already started above |
   | containers | `podman run --detach --publish 5432:5432 --env POSTGRES_USER=root postgres` |

#### Kafka

1. Install

   |            |     |
   | ---------- | --- |
   | dnf        | `sudo dnf -y install kafka` |
   | yum        | `sudo yum -y install kafka` |
   | apt        | `sudo apt -y install kafka` |
   | brew       | `brew install java kafka` |
   | containers | N/A |

2. Configure the service

   * macOS
     * Configure system to use Java

       ```bash
       sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
       ```

     * Configure KRaft (optional, if not using zookeeper)

       ```bash
       mv $(brew --prefix)/etc/kafka/server.properties $(brew --prefix)/etc/kafka/server.properties-zookeeper
       ln -s $(brew --prefix)/etc/kafka/kraft/server.properties $(brew --prefix)/etc/kafka/

       kafka-storage format -t $(kafka-storage random-uuid) -c $(brew --prefix)/etc/kafka/server.properties
       ```

3. Start the service

   |            |     |
   | ---------- | --- |
   | systemd    | `systemctl enable --now kafka` |
   | brew       | `brew services start kafka`, `brew services start zookeeper` |

### nvm and JavaScript build utilities

[nvm](https://github.com/nvm-sh/nvm) is *strongly* recommended for NodeJS version management.

```bash
nvm install 20
nvm use 20

# Set version 20 as the default for all scripts
nvm alias default 20
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

Using the Ruby version manager, install Ruby and the latest `bundler` (as listed in the [Requirements Summary](#requirements-summary) above).

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

- macOS requires platform specific Gems. Run `bundle config specific_platform true` before running `bin/setup`.

- If you've run PostgreSQL in a container, be sure to export the `DATABASE_URL` variable to connect to the container over TCP instead of a UNIX file socket.

  ```bash
  export DATABASE_URL='postgresql://localhost:5432' # optional, only necessary if PostgreSQL is running in a container
  ```

## Start ManageIQ

```bash
bundle exec rails server
```

The web UI should now be available at `http://localhost:3000`. The default username is `admin` and the default password is `smartvm`.  If you can login, then everything is working!  Press Ctrl-C to stop the Rails server.

ManageIQ runs a lot of work asynchronously via background queue workers, to simulate this we recommend running:
```bash
bundle exec rails console
simulate_queue_worker
```

## macOS AirDrop & Handoff Listens on Port 5000

If you run workers like we do on appliances using `ruby lib/workers/bin/evm_server.rb`, remote console workers will try to bind to port 5000. This can fail on macOS with:

```
Address already in use - bind(2) for "0.0.0.0" port 5000
```

This is because the AirPlay Receiver on macOS listens on port 5000.  You can disable this feature here:

```
System Settings > General > AirDrop & Handoff > AirPlay Receiver.
```

Alternatively, you can use [foreman](developer_setup/foreman.md) to start workers.

## Further Reading

* [Individual workers](developer_setup/foreman.md) can be started using [Foreman](https://ddollar.github.io/foreman) directly.
* [Running the test suites](developer_setup/running_test_suites.md)
* [Seeding inventory data from provider tests](developer_setup/seeding_test_inventory.md)
* [Provider, UI and plugin development](developer_setup/plugins.md) describes the plugin and external provider development process.
* [ManageIQ Bot](https://github.com/ManageIQ/miq_bot#manageiq-bot) a bot to automate various developer problems such as commit monitoring, Github pull request and Travis monitoring.
