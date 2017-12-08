## Embedded Ansbile - via AWX in a docker container

ManageIQ supports more than one way (`manageiq/lib/embedded_ansible*`) of connecting to the Embedded Ansible provider.

Here, we'll set up `DockerEmbeddedAnsible`, introduced in [ManageIQ/manageiq#16205](https://github.com/ManageIQ/manageiq/pull/16205) - this will download an awx docker container, and set local manageiq to connect to it.



### Dependencies

You need docker.

On a mac, you also need `docker-machine`:

```
brew install docker docker-machine

# read the output and start the service

# run this in your .bashrc, or every shell where needed
eval `docker-machine env default`
```


### DB config

Your PostgreSQL must be configured to allow connections from the docker container, so that AWX can connect to manageiq's database.

Your ManageIQ DB user (the one in `manageiq/config/database.yml`) must have the `SUPERUSER` privilege (or at least needs to be able to create roles and databases).


Config file locations:

  * Debian: `/etc/postgresql/9.6/main/`
  * Fedora: `/var/lib/pgsql/data/`
  * MacOSX: `/usr/local/var/postgres/`


Make sure your `postgresql.conf` contains this line:

```
listen_addresses = '*'
```


Make sure your `pg_hba.conf` contains:

```
host	all	all	172.17.0.1/24	md5
```

Mac users: you may also need to add this one, for `docker-machine`.

```
host all all 192.168.99.0/24 md5
```


Ensure your DB user (the one in `config/database.yml`) has `superuser` rights..

  * Debian: `sudo su - postgres -c psql -c 'ALTER ROLE "root" SUPERUSER'`
  * Fedora / MacOSX: `psql -c 'ALTER ROLE "root" SUPERUSER' postgres`


### Clean up

If you've already set up an AWX instance this way and want to clean it up:

```
psql -d postgres -c 'DROP DATABASE awx'
psql -d postgres -c 'DROP ROLE awx'
bin/rake evm:db:reset
bin/rake db:seed
```


If you had previously added an embedded ansible using the [old way](http://talk.manageiq.org/t/howto-setup-embedded-ansible/2291/5?u=himdel), you'll need to clean up the provider (in Rails console):

```
ManageIQ::Providers::EmbeddedAnsible::Provider.first.destroy!
```


In both cases, you may also need to clean up the old authentications (in Rails console):

```
db = MiqDatabase.first
db.authentication_type('ansible_secret_key').delete    # db.ansible_secret_key.delete
db.ansible_rabbitmq_authentication.delete
db.ansible_admin_authentication.delete
db.ansible_database_authentication.delete
```


### Procfiles

Under your `manageiq/` directory, create these 2 files:

`Procfile.ansible`:

```
ansible: ruby lib/workers/bin/run_single_worker.rb EmbeddedAnsibleWorker
```

`Procfile.workers`:

```
generic:                  ruby lib/workers/bin/run_single_worker.rb MiqGenericWorker
embedded_ansible_refresh: ruby lib/workers/bin/run_single_worker.rb -e 123 ManageIQ::Providers::EmbeddedAnsible::AutomationManager::RefreshWorker
embedded_ansible_event:   ruby lib/workers/bin/run_single_worker.rb -e 123 ManageIQ::Providers::EmbeddedAnsible::AutomationManager::EventCatcher
```

In the second file, you'll need to replace that 123 with the id of the newly created **manager** instance.


### Setting it up

  * configure your server to enable the ansible role (from Rails console):

```
server = MiqServer.my_server(true)
server.role = "embedded_ansible,ems_inventory,ems_operations,event"
server.activate_roles(%w(embedded_ansible ems_inventory ems_operations event))
server.save!
```

   * run rails: `bin/rails s`

   * run the worker that will download and set up the container: `foreman start -f Procfile.ansible`

   * grab a coffee or two - you can watch the progress by watching:
      * authentication errors, docker problems: `tail -f managiq/log/evm.log`
      * running containers: `docker ps`
      * container logs: `docker logs -f awx_web`
      * seeing awx initial upgrade progress `localhost:54321`

   * once everything suceeded, you should see `Finished starting embedded ansible service.` in `evm.log`

   * if you got that far, AWX is running and ManageIQ has an EmbeddedAnsible provider instance

   * you need to edit `Procfile.workers`, to replace that `123` with the actual id of the new manager (not provider) instance:

```
ManageIQ::Providers::EmbeddedAnsible::Provider.first.managers.first.id
```

   * run `foreman start -f Procfile.workers`

   * try adding a Repository in ManageIQ (Automate > Ansible > Repositories) :)


If you're on MacOSX, you will also need to run these first:

```
# redirect local 54321 to docker-machine - otherwise, localhost:54321 doesn't work
docker-machine ssh default -L 54321:127.0.0.1:54321

# inside that docker-machine ssh shell - redirect postgres from the docker machine to the real one (otherwise, awx_web can't connect to manageiq DB)
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
sudo iptables -t nat -I PREROUTING --dst 172.17.0.1 -p tcp --dport 5432 -j DNAT --to-destination 192.168.99.1:5432

# don't exit the shell
```

(`172.17.0.1` is the docker host IP address, `192.168.99.1` is the adress `docker-machine` gives to the host (the VM will have `192.168.99.100` most likely))


### Running it again

Just run these 3, each in a different terminal:

```
bin/rails s
foreman start -f Procfile.ansible
foreman start -f Procfile.workers
```


On a mac, you'll also need to do the `docker-machine ssh...` command running.
And if you've restarted the machine (or `docker-machine`) since the last time, you'll also need the `iptables...` command.


### Connecting to AWX directly

Your docker awx instance is listening on `localhost:54321`.

To log in, you can use the `admin` account - to determine the password, run Rails console and do:

```
MiqDatabase.first.ansible_admin_authentication.password
```


### Troubleshooting

  * watch `manageiq/log/evm.log`

```
# should see this in evm.log
[----] I, [2017-12-07T11:32:46.833998 #29139:2acb0db2ef8c]  INFO -- : MIQ(EmbeddedAnsibleWorker::Runner#setup_ansible) Starting embedded ansible service ...
[----] I, [2017-12-07T11:33:06.637266 #29139:2acb0db2ef8c]  INFO -- : MIQ(DockerEmbeddedAnsible#start) Waiting for Ansible container to respond
... a whole lot of this ....
[----] I, [2017-12-07T11:33:08.732190 #29139:2acb0db2ef8c]  INFO -- : MIQ(DockerEmbeddedAnsible#start) Waiting for Ansible container to respond
[----] I, [2017-12-07T11:33:13.530599 #29139:2acb0db2ef8c]  INFO -- : MIQ(EmbeddedAnsibleWorker::Runner#setup_ansible) Finished starting embedded ansible service.
[----] I, [2017-12-07T11:33:15.605973 #29139:2acb0db2ef8c]  INFO -- : MIQ(ManageIQ::Providers::EmbeddedAnsible::Provider#with_provider_connection) Connecting through ManageIQ::Providers::EmbeddedAnsible::Provider: [Embedded Ansible]
[----] I, [2017-12-07T11:33:16.033227 #29139:2acb0db2ef8c]  INFO -- : MIQ(AuthUseridPassword#validation_successful) [Provider] [1], previously valid/invalid on: []/[], previous status: []
```

  * watch docker container output - for problems like awx not being able to connect to ManageIQ database

```
docker logs -f awx_web
```

  * watch `docker ps` output

```
# should see this in `docker ps`
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                                NAMES
d10993d1f25b        ansible/awx_task:latest   "/tini -- /bin/sh ..."   6 seconds ago       Up 5 seconds        8052/tcp                             awx_task
b63a677d32a7        ansible/awx_web:latest    "/tini -- /bin/sh ..."   7 seconds ago       Up 6 seconds        0.0.0.0:54321->8052/tcp              awx_web
59806de1bcd1        memcached:alpine          "docker-entrypoint..."   27 seconds ago      Up 26 seconds       11211/tcp                            memcached
a89aa0e4a395        rabbitmq:3                "docker-entrypoint..."   27 seconds ago      Up 26 seconds       4369/tcp, 5671-5672/tcp, 25672/tcp   rabbitmq
```
