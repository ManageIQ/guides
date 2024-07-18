## ManageIQ Openshift Container Provider

Two deployment options are suggested here to deploy an openshift origin
provider for ManageIQ:

- using [openshift-ansible](https://github.com/openshift/openshift-ansible) to
  deploy RPM packages on a cluster
- using [CodeReady Containers](https://github.com/crc-org/crc) to deploy
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

### Running with CodeReady Containers


If you want to develop with an OpenShift 4 provider, CodeReady Containers (CRC)
is a great option.  It provides all of benefits as minishift (a simple single
vm openshift on your development machine) but is an OpenShift v4 cluster.


#### Requirements

* [`CodeReady Containers`](https://github.com/crc-org/crc) ([Installation Instructions](https://crc.dev/crc/getting_started/getting_started/installing/))
* A compatible [Operating System](https://crc.dev/crc/getting_started/getting_started/installing/#_operating_system_requirements)

#### Quickstart

1. [Download](https://console.redhat.com/openshift/create/local) ane extract the latest release of CRC

    ```console
    tar xfJ crc-linux-amd64.tar.xz
    ```
2. Copy the crc binary to a location on your PATH

    ```console
    sudo install crc-linux-2.39.0-amd64/crc /usr/local/bin/crc
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

5. Now you can setup the project and service account for use with ManageIQ by following the documentation: https://www.manageiq.org/docs/reference/latest/managing_providers/containers_providers/red_hat_openshift_providers.html

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
