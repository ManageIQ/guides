## ManageIQ Openshift Container Provider

Two deployment options are suggested here to deploy an openshift origin
provider for ManageIQ:

- using [openshift-ansible](https://github.com/openshift/openshift-ansible) to
  deploy RPM packages on a cluster
- using [minishift](https://github.com/minishift/minishift) to deploy
  openshift source to a vm

You can also use `oc cluster up` and configure it yourself (instructions not
provided) as another alternative.

### Deploying OpenShift With Ansible

Get openshift-ansible:

```console
$ git clone https://github.com/openshift/openshift-ansible.git
```

Generate an ssh key if needed:

```console
$ ssh-keygen
```

Configure ssh key authentication to all the machines:

```console
$ ssh-copy-id root@hostname
```

The inventory file describes all the nodes and masters in the cluster. A simple
example file for a cluster composed of two machines (Master and Node):

```INI
[OSEv3:children]
masters
nodes
 
[OSEv3:vars]
ansible_ssh_user=root
deployment_type=origin
 
[masters]
master_hostname openshift_scheduleable=True
 
[nodes]
master_hostname
node_hostname
```

There are more like variables like `use_metrics` to enable other options in
OpenShift.  A more detailed example can be found in
`inventory/byo/hosts.origin.example`. Specifically, to deploy metrics and
logging use `openshift_hosted_metrics_deploy=True` and
`openshift_hosted_logging_deploy=True`

```console
$ ansible-playbook playbooks/byo/config.yml -i path/to/inventory/file
```


### Running with minishift


For a simple single host setup for working with the openshift provider locally,
you can use [`minishift`](https://github.com/minishift/minishift) to run a
local openshift instance.


#### Requirements

* [`minishift`](https://github.com/minishift/minishift) >= 1.0.0.rc1 ([Installation Instructions](https://docs.openshift.org/latest/minishift/getting-started/installing.html#installing-instructions))
* Virtualization host of your choice (see supported hypervisors [here](https://docs.openshift.org/latest/minishift/getting-started/installing.html#install-prerequisites))


#### Quickstart

Since VirtualBox is a consistent hypervisor across all platforms, this guide
will assume that is being used, and updates to some commands might be
necessary (most commands should be virtualization software agnostic and work
regardless of the hypervisor).

1. Download and enable the manageiq addon for minishift:
  
   ```console
   $ mkdir -p ~/minishift/addons
   $ git clone https://gist.github.com/e2fac8be87ea0e9f429b6f5d75e02176 ~/minishift/addons/manageiq
   $ minishift addons install --force ~/minishift/addons/manageiq
   $ minishift addons enable manageiq
   ```
   
2. Start minishift:
   
   ```console
   $ minishift start --vm-driver virtualbox --openshift-version "v3.6.1"
   ```
   
   You might want to add `--metrics --memory 5G`.  As of this writing that only supports hawkular and doesn't work on 3.7.0.
    
   See https://hub.docker.com/r/openshift/origin/tags/ for possible versions.
   
3. Grab the minishift IP:
   
   ```console
   $ minishift ip
   ```
   
4. Add `oc` and/or `docker` to your PATH, configured to the cluster (auto-detects correct shell):
   
   ```console
   $ eval $(minishift oc-env)
   $ eval $(minishift docker-env)
   ```
   
5. Grab the token to access openshift through `manageiq`:
   
   ```console
   $ oc login -u system:admin
   $ oc sa get-token -n management-infra management-admin
   ```
   
6. Configure a provider in ManageIQ, filling in your token and IP where
   appropriate:
   
   ```console
   $ bin/rails c
   irb> token = '<<YOUR_TOKEN_FROM_ABOVE_HERE>>'
   irb> host  = '<<YOUR_IP_FROM_ABOVE_HERE>>'
   irb> os = ManageIQ::Providers::Openshift::ContainerManager
   irb> os.create(:name => "Minishift", :hostname => host, :port => 8443, :ipaddress => host, :zone => Zone.first, :storage_profiles => [], :security_protocol => "ssl-without-validation")
   irb> os.last.update_authentication(:bearer => {:auth_key => token, :save => true})
   ```
   
   Or through the UI if you prefer.

### Automated script to record new VCR

https://github.com/ManageIQ/manageiq-providers-openshift/pull/75 added a script that creates things from template, records 1st vcr, deletes some things, records 2nd.

Currently if you want to copy VCR to manageiq-providers-kubernetes, the spec there assumes Hawkular metrics were running.

- Easiest to use script with minishift.  
  Have `minishift` in your PATH.
  As described above, including manageiq addon.  Don't need `--metrics`.

- Alternatively bring your own openshift.
  Set `OPENSHIFT_MASTER_HOST` env var.
  Perform `oc login` as a user having `cluster-admin` role.

Then run in manageiq-providers-openshift repo:
```
./spec/vcr_cassettes/manageiq/providers/openshift/container_manager/test_objects_record.sh
```

You may need to adjust specs if object counts and/or names changed (ideally, figure out why and how to make it more reproducible).

There are text files near the .yml files that help tracking what changed vs previous VCRs, commit them together.
