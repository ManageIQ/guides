## ManageIQ Openshift Container Provider

### Deploying OpenShift With Ansible
Get openshift-ansible:

```git clone https://github.com/openshift/openshift-ansible.git```

Generate an ssh key if needed:

``ssh-keygen```

Configure ssh key authentication to all the machines:

```ssh-copy-id root@hostname```

The inventory file describes all the nodes and masters in the cluster. A simple example file for a cluster composed of two machines (Master and Node):

```[OSEv3:children]
masters
nodes
 
[OSEv3:vars]
ansible_ssh_user=root
deployment_type=origin
openshift_use_manageiq=True
 
[masters]
master_hostname openshift_scheduleable=True
 
[nodes]
master_hostname
node_hostname
```

openshift_use_manageiq is set to True to configure the Service Account needed by ManageIQ. there are more like variables like use_metrics to enable other options in OpenShift.
A more detailed example will be found in inventory/byo/hosts.example.

openshift_use_manageiq is set to True to configure the Service Account needed by ManageIQ. there are more like variables like use_metrics to enable other options in OpenShift.
A more detailed example will be found in inventory/byo/hosts.example.
```ansible-playbook playbooks/byo/config.yml -i path/to/inventory/file```
