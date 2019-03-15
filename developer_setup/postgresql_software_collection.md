Currently ManageIQ requires version 10 of PostgreSQL, but the
version included in some Linux distributions (CentOS and RHEL 7, for
example) is 9.2, and that won't change in the near future.

In order to use version 10 you can use the packages provided by
[SoftwareCollections.org](https://www.softwarecollections.org/en/scls/rhscl/rh-postgresql10/).

## Enable the _SoftwareCollections.org_ repository

The first thing you need to do is to enable the
_SoftwareCollections.org_ package repository. If you are using _CentOS_
then the command is the following:

    $ sudo yum -y install centos-release-scl

## Make sure that old packages are removed

If you have older versions of the `postgresql` packages installed you
may encounter conflicts with network ports, so it is good idea to stop
the database and remove those older packages before installing the new
version:

    $ sudo systemctl stop postgresql-server
    $ sudo systemctl disable postgresql-server
    $ sudo yum -y remove 'postgresql-*'

The `pg` gem will also need to be re-compiled, so make sure you remove
it:

     $ gem uninstall pg

It will be re-compiled and re-installed the next time you run
`bin/setup`.

## Install the _PostgreSQL 10_ collection

Then you need to install the software collection for version 10 (or
newer) of _PostgreSQL_:

    $ sudo yum -y install \
    rh-postgresql10-postgresql-server \
    rh-postgresql10-postgresql-devel

This will install the required files under `/opt/rh/rh-postgresql10`, so
each time you need to use a command like `pgsql` you will have to use
the complete path. Alternatively, you can _enable_ that collection:

    $ scl enable rh-postgresql10 bash

This will spawn a new shell where you can use the commands without the
full path, and it is useful when don't need to run commands frequently.
But as you will probably want to run commands like `psql`quite often, it
is better to enable the collection permanently, adding the following to
the relevant `.bash_profile` files:

    source /opt/rh/rh-postgresql10/enable

It is good idea to add this to your personal `.bash_profile`:

    $ cat > $HOME/.bash_profile <<.
    source /opt/rh/rh-postgresql10/enable
    .

## Create and configure the database

By default the database directory used by the software collection is
`/var/opt/rh/rh-postgresql10/lib/pgsql/data`, but the ManageIQ
instructions assume it to be `/var/lib/pgsql/data`. The name of the
service is also different. Make sure to take these differences into
account when creating and configure the database. For example, to
initially create the database you will need to do the following:

    $ su - root
    # scl enable rh-postgresql10 bash
    # postgresql-setup initdb

To setup authentication you will need to modify the `pg_hba.conf` file,
as described in the instructions, but taking into account the different
location:

    $ PGDATA=/var/opt/rh/rh-postgresql10/lib/pgsql/data
    $ sudo grep -q '^local\s' $PGDATA/pg_hba.conf || echo "local all all trust" | sudo tee -a $PGDATA/pg_hba.conf
    $ sudo sed -i.bak 's/\(^local\s*\w*\s*\w*\s*\)\(peer$\)/\1trust/' $PGDATA/pg_hba.conf

To enable and start the server:

    $ sudo systemctl enable rh-postgresql10-postgresql
    $ sudo systemctl start rh-postgresql10-postgresql

And, finally, to create the database user:

    $ su - postgres
    $ scl enable rh-postgresql10 bash
    $ psql -c "CREATE ROLE root SUPERUSER LOGIN PASSWORD 'smartvm'"
