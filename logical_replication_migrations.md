# Testing logical replication with migrations

## Introduction

ManageIQ uses logical replication to provide central administrative functions over objects in other
database regions.  In order to do this, we use postgresql's logical replication to setup
publications for specific tables in remote regions and subscriptions for each in the central or
global region.

Note, this is completely different from HA and failover.  Logical replication provides product
features such as being able to start or stop a virtual machine centrally regardless of which
database it resides.  HA, on the other hand, provides for failover by promoting a backup when a
primary database fails.

This interconnectedness of multiple databases with publications and subscriptions with ManageIQ
regions means that the upgrade process is a bit different.  Basically, the central region cannot be
migrated until all databases it's subscribing to have been migrated.  Fortunately, this logic
should be mostly automatic.

This logic is what we're trying to test and verify.

## Pre-requisites

I tested with 3 nightly appliances.  They were setup to be at the Jansa codebase with replication.
They were then migrated to kasparov.  This document could be used for different branches or tags.

I used the following region numbers:
* 99 - global
* 1 - remote
* 2 - remote

I assume you'll be running this in production mode on appliances.  If not, you'll need to export
RAILS_ENV on the 3 terminals if you're not using appliances:

```
export RAILS_ENV=production
```

## Initial setup

I cloned ManageIQ and checked out the jansa branch on all 3 appliances, renaming the existing vmdb
directory from the rpm, and installed the rpms needed in order to build andy compiled gems.

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

For each appliance, we'll
* Checkout the source version (jansa)
* Bundle our gem dependencies
* Initialize the encryption key and default database.yml
* Setup our region number
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
  * We'll set them up as remotes which will create the publications.

  ```
  vmdb
  bin/rails r "MiqRegion.replication_type= :remote"
  ```


* Region 99 (global):
  * We'll specify the remote region connection information and create the subscriptions.
  
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

Now, we wait and verify that replication is working before moving on.

On the global:

```
bin/rails c
```

```
User.all.pluck(:id)
# This should show ids beginning with the 3 region numbers: 99, 1, 2.
```

## Remove replication before upgrade

On the global, assuming the remotes are region 1 and 2:

```
psql -U root vmdb_production -h global_ipaddress -c 'DROP subscription region_1_subscription;'
psql -U root vmdb_production -h global_ipaddress -c 'DROP subscription region_2_subscription;'
```

Note:  Dropping the subscription on the global will also delete the slot on the remote and will do
proper cleanup.  

## Upgrade to kasparov

On region 1, 2, and 99:

```
vmdb
git checkout origin/kasparov
bundle check || bundle update
```

## Configure replication for kasparov

Same instructions as [above](#configure-replication-for-jansa).

## Attempt migration from global

```
vmdb
bin/rake db:migrate
```

You'll notice it's waiting on the remote region 1 and will not complete:

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

Now, region 99 terminal shows:
```
Waiting for remote region 1 to run migration 20200424183342
Waiting for remote region 2 to run migration 20200424183342
```

It's now waiting on the remote region 2 and will not complete.

## Migrate database to kasparov on region 2

On region 2:

```
vmdb
bin/rake db:migrate
```

Now, once region 2 migrates, region 99 will immediately migrate.
