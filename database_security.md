# configuring databases in rails environments

There are a few ways to hook up a rails app to a postgres database, but it seems most apps tend to go towards a username password route. This is attempting to share our experiences and get a good conversation going about how rails could move forward. This is not really specific to rails or postgres.

The configurations focus on a few files and 
We will look at the list of files of interest, 

We tweak just a few files:

- `database.yml`
- `postgresql.conf`
- `pg_hba.conf`
- `pg_ident.conf`

These files give us a few connectivity scenarios:

- local disk unix socket
- local socket connection
- network socket with password stored in `database.yml`
- network socket with password stored in environment variables
- encrypted password stored in `database.yml` (non-standard)
- network socket ssl secured connection


# Files

## `$RAILS_ROOT/config/database.yml`

In our appliance, this lives in `/var/www/miq/vmdb/config/`. It tells rails how to connect to the database.

```
---
base: &base
  adapter: postgresql
  encoding: utf8
  host: localhost
  username: postgres
  password: "X"
  pool: 1
  wait_timeout: 5

production:
  <<: *base
  database: vmdb_production
```

## `~/.postgresql/`

The sql adapter (the `pg` gem) will read this from the web app user's home directory, or our application, that is  `/root/.postgresql/`.

It contains 3 files:

- `postgresql.crt` - the webapp's public key and certificate stating the client's identiy.
- `postgresql.key` - the webapp's private key and certificate to protect the client's identiy.
- `root.crt` - the certificate of the CA (certificate authority) that signed the postgres server's key.

## `$POSTGRES_ROOT/postgresql.conf`

Postgres configuration file.
The ssl certs have been moved into a separate directory to make SELinux easier to configure.


```
#unix_socket_directory = '/tmp'
#ssl = on
#ssl_cert_file = 'certs/server.crt'
#ssl_key_file  = 'certs/server.key'
#ssl_ca_file   = 'certs/ca.crt'
#ssl_crl_file = 'certs/root.crl'
```

## `$POSTGRES_ROOT/pg_hba.conf`

Postgres host based authentication file.

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local    all             all                                    peer map=usermap
host     all             all            127.0.0.1/32            ident map=usermap
#host    all             all            *                       md5
hostssl  all             all            all                     cert map=sslmap
```

- local means the socket defined by unix_socket_directory. Typically this is `/tmp` but some distros use different values, including some inconsistencies on this value for OS X.

## `$POSTGRES_ROOT/pg_ident.conf`

User Name mapping that allows a user to login as another user. For ssl certificates this is often necessary since the ssl common name may not be setup correctly

```
# MAPNAME       SYSTEM-USERNAME         PG-USERNAME
usermap         root                    postgres
# ssl mappings
sslmap          root                    postgres
```

# Scenarios

## local disk unix socket

