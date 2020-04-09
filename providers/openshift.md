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
local openshift 3.x instance.


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


### Running with CodeReady Containers


If you want to develop with an OpenShift 4 provider, CodeReady Containers (CRC)
is a great option.  It provides all of benefits as minishift (a simple single
vm openshift on your development machine) but is an OpenShift v4 cluster.


#### Requirements

* [`CodeReady Containers`](https://github.com/code-ready/crc) ([Installation Instructions](https://code-ready.github.io/crc/#installation_gsg))
* A compatible [Operating System](https://code-ready.github.io/crc/#minimum-system-requirements-operating-system_gsg) and the [Required software packages](https://code-ready.github.io/crc/#required-software-packages_gsg)

#### Quickstart

1. [Download](https://cloud.redhat.com/openshift/install/crc/installer-provisioned) ane extract the latest release of CRC

    ```console
    tar xfJ crc-linux-amd64.tar.xz
    ```
2. Copy the crc binary to a location on your PATH

    ```console
    sudo cp crc-linux-1.8.0-amd64/crc /usr/local/bin
    which crc
    /usr/local/bin/crc
    ```

3. Setup and start CRC (it will ask for an image pull secret which you can get from [cloud.redhat.com](https://cloud.redhat.com/openshift/install/crc/installer-provisioned))

    ```console
    crc setup
    INFO Checking if oc binary is cached
    ...

    Setup is complete, you can now run 'crc start' to start the OpenShift cluster
    crc start
    ...
    ? Image pull secret [? for help]
    ```

4. Login to the cluster with `oc`, the command will be printed when `crc start` finishes or you can call `crc console --credentials`
    ```console
    crc console --credentials
    oc login -u kubeadmin -p KUBEADMING_PASSWORD https://api.crc.testing:6443
    ```

5. Now you can setup the management-infra/management-admin service account for use with ManageIQ
    ```console
    git clone https://gist.github.com/e2fac8be87ea0e9f429b6f5d75e02176 /tmp/manageiq_crc
    oc adm new-project management-infra --description="Management-Infrastructure"
    oc create serviceaccount management-admin -n management-infra
    oc create -f /tmp/manageiq_crc/management-infra-admin-cluster-role.json
    oc policy add-role-to-user -n management-infra admin -z management-admin
    oc policy add-role-to-user -n management-infra management-infra-admin -z management-admin
    oc adm policy add-cluster-role-to-user cluster-reader system:serviceaccount:management-infra:management-admin
    oc adm policy add-scc-to-user privileged system:serviceaccount:management-infra:management-admin
    oc adm policy add-cluster-role-to-user system:image-puller system:serviceaccount:management-infra:inspector-admin
    oc adm policy add-scc-to-user privileged system:serviceaccount:management-infra:inspector-admin
    oc adm policy add-cluster-role-to-user self-provisioner system:serviceaccount:management-infra:management-admin
    ```

6. Grab the console IP address and token to acess CRC through `ManageIQ`
    ```console
    cluster_ip=$(crc ip)
    service_account_token=$(oc sa get-token -n management-infra management-admin)
    ```

7. Configure a provider in ManageIQ
    ```console
    rails r "ManageIQ::Providers::Openshift::ContainerManager.create!(:name => 'CRC', :hostname => '$cluster_ip', :port => 6443, :zone => Zone.visible.first, :security_protocol => 'ssl-without-validation').update_authentication(:bearer => {:auth_key => '$service_account_token'})"
    ```

### Automated script to record new VCR

https://github.com/ManageIQ/manageiq-providers-openshift/pull/75 added a script that creates things from template, records 1st vcr, deletes some things, records 2nd.

Currently if you want to copy VCR to manageiq-providers-kubernetes, the spec there assumes Hawkular metrics were running.

- Easiest to use script with minishift/crc.  
  Have `minishift` or `crc` in your PATH.
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
