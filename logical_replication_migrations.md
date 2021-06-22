# Testing logical replication with migrations

## Introduction

ManageIQ uses logical replication to provide central administrative functions over objects in other
database regions.  In order to do this, postgresql's logical replication is used to setup
publications for specific tables in remote regions and subscriptions for each in the central or
global region.

Note, this is completely different from HA and failover.  Logical replication provides product
features such as being able to start or stop a virtual machine centrally regardless of which
database it resides in.  HA, on the other hand, provides for failover by promoting a backup when a
primary database fails.

This interconnectedness of multiple databases with publications and subscriptions with ManageIQ
regions means that the upgrade process is a bit different.  Basically, the global region cannot be
migrated until all databases it's subscribing to have been migrated.  Fortunately, this logic
should be mostly automatic.

This logic is what we're trying to test and verify.

## Pre-requisites

This was tested with 3 nightly appliances.  They were setup to be at the Jansa codebase with
replication. The appliances were then migrated to kasparov.  This document could be used for
different branches or tags.

The following region numbers were used and will be referenced throughout this document.  Replace
these values if different numbers are selected:
* 99 - global
* 1 - remote
* 2 - remote

It is assumed the application will be run in production mode on appliances.  This is the default
on appliances.  If using a different mode or not appliances, RAILS_ENV will need to be exported:

```
export RAILS_ENV=production
```

## Initial setup

* The existing manageiq code from the rpm in /var/www/miq/vmdb was renamed
* ManageIQ was cloned and checked out at the jansa branch
* Now, install all rpms required to build compiled gems:

These commands were found in the [rpm_build Dockerfile](https://github.com/ManageIQ/manageiq-rpm_build/blob/ec0fcc85f7d24010278148f4bab83447d18884b5/Dockerfile#L22-L45).

```
    dnf -y group install "development tools" && \
    dnf config-manager --setopt=epel.exclude=*qpid-proton* --setopt=tsflags=nodocs --save && \
    dnf -y install \
      ansible \
      cmake \
      copr-cli \
      glibc-langpack-en \
      libcurl-devel \
      libpq-devel \
      librdkafka \
      libssh2-devel \
      libxml2-devel \
      libxslt-devel \
      nodejs \
      openssl-devel \
      platform-python-devel \
      postgresql-server \
      postgresql-server-devel \
      qpid-proton-c-devel \
      ruby-devel \
      rubygem-bundler \
      wget \
      sqlite-devel && \
    dnf clean all
```

## Prepare for replication on jansa

The commands below will be run on each appliance and will do the following:
* Checkout the source version (jansa)
* Bundle the gem dependencies
* Initialize the encryption key and default database.yml
* Setup the region number
* Seed the database

Note: Setting RAILS_ENV is not required on appliances as they default to production, but is provided
below for completeness.

```
export DISABLE_DATABASE_ENVIRONMENT_CHECK=1
vmdb
git checkout origin/jansa
bundle check || bundle update
mkdir log
cp -f certs/v2_key.dev certs/v2_key
cp -f config/database.pg.yml config/database.yml
bundle exec rake evm:db:region -- --region XXX
bundle exec rake --trace  db:migrate
bundle exec rake --trace  db:seed
```

Substitute XXX for the region number of this appliance:
* 99 - global
* 1 - remote
* 2 - remote

## Configure replication for jansa

* Region 1 and 2: 
  * These will be remotes, meaning they will "publish" the tables to be replicated:

  ```
  vmdb
  bin/rails r "MiqRegion.replication_type= :remote"
  ```


* Region 99 (global):
  * The commands below will:
    * Provide the other regions' connection information
    * Create the subscription for each remote region
  
  ```
  bin/rails c
  ```

  Subsitute the proper values below:

  ```
  $ require 'miq_pglogical'
  host1 = 'x.x.x.x'
  host2 = 'y.y.y.y'
  port = '5432'
  user = 'root'
  password = 'zzz'
  sub1 = PglogicalSubscription.new(:host => host1, :port => port, :user => user, :dbname => 'vmdb_production', :password => password)
  sub2 = PglogicalSubscription.new(:host => host2, :port => port, :user => user, :dbname => 'vmdb_production', :password => password)
  MiqPglogical.save_global_region([sub1, sub2], [])
  ```

Now, replication can verified before moving on.

On the global:

```
bin/rails c
```

```
User.all.pluck(:id)
# This should show ids beginning with the 3 region numbers: 99, 1, 2.
```

Note, it may take a few minutes before these users are replicated.

## Remove replication before upgrade

Whenever performing an upgrade, logical replication must be disabled on the old version and enabled
again on the new version.  Often, this is because appliances are replaced and therefore the
publication and subscription are different.  Even when not replacing appliances, it is still best to
disable replication on the old version and enable it again on the new version so that the correct
version of code is adding the publications and subscriptions.

On the global, assuming the remotes are region 1 and 2:

```
psql -U root vmdb_production -h global_ipaddress -c 'DROP subscription region_1_subscription;'
psql -U root vmdb_production -h global_ipaddress -c 'DROP subscription region_2_subscription;'
```

Note:  Dropping the subscription on the global will also delete the replication slot on the remote
and will do proper cleanup.  The replication slot should not be manually removed.

## Upgrade to kasparov

On region 1, 2, and 99:

```
vmdb
git checkout origin/kasparov
bundle check || bundle update
```

## Configure replication for kasparov

Follow the same instructions as [above](#configure-replication-for-jansa)

## Attempt migration from global

```
vmdb
bin/rake db:migrate
```

Notice that the global will not migrate the database as it is waiting on region 1 to migrate first:

```
 Waiting for remote region 1 to run migration 20200424183342
```

Leave region 1's terminal waiting for the other regions to migrate...

## Migrate database to kasparov on region 1

On region 1:

```
vmdb
bin/rake db:migrate
```

Now, region 99 (global) terminal shows:
```
Waiting for remote region 1 to run migration 20200424183342
Waiting for remote region 2 to run migration 20200424183342
```

It is now waiting on region 2 and will not complete yet.

## Migrate database to kasparov on region 2

On region 2:

```
vmdb
bin/rake db:migrate
```

After region 2 migrates, region 99 will immediately migrate.
