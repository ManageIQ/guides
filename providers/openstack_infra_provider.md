## ManageIQ OpenStack Infrastructure Provider

The OpenStack infrastructure provider is designed to work with a [TripleO-based OpenStack deployment](https://wiki.openstack.org/wiki/TripleO).  It provides visibility and management capabilities for the undercloud.

### Features

* Scaling of the overcloud through ManageIQ
   * Function enabled through both the UI and Automate
* Host data collection
   * Base attributes through OpenStack APIs (Ironic, Heat, Tuskar)
   * Metrics through OpenStack Ceilometer
   * OpenStack component views, detailing the status and configuration of installed OpenStack services, through host fleecing
* Image data collection through the OpenStack Glance API

### In Development

* Exposing additional management capabilities provided by OpenStack APIs

### Installation

##### Install a TripleO-based OpenStack deployment

The recommended way to do this can be found here: https://www.rdoproject.org/tripleo/

Afterwards, you'll need to expose the undercloud's API endpoints: https://wiki.openstack.org/wiki/Tuskar/Instack#Connecting_to_Undercloud_from_external_place_.28e.g._your_laptop.29

###### Enable Events in the Undercloud

To enable events in the undercloud, update the following configuration files on the undercloud node:

* /etc/heat/heat.conf
   * notification_driver=messaging
   * notification_topics=notifications
* /etc/nova/nova.conf
   * notification_driver = messaging
   * notification_topics = notifications

Then, restart all Heat and Nova services.

##### Install ManageIQ

* https://github.com/ManageIQ/guides/blob/master/developer_setup.md
* https://github.com/ManageIQ/guides/blob/master/developer_ruby2_setup.md

##### Add the TripleO-based OpenStack deployment (undercloud) to ManageIQ

Follow these steps to add a TripleO-based OpenStack deployment (undercloud) to ManageIQ

* Go to Infrastructure -> Providers
* Under 'Configuration' select 'Add a New Infrastructure Provider'
* In the resulting form, choose 'OpenStack Infrastructure' as the Type and fill in the 'Basic Information' and 'Credentials' form
   * Note that the IP Address must match the IP shown when running 'keystone endpoint-list' in the undercloud

##### Enable Host Fleecing (Optional)

Follow these steps to enable host fleecing.  Note that the OpenStack infrastructure provider will still work if these steps are not run; there will simply be less information available through the ManageIQ UI.

* Enable the SmartProxy role:
   * Go to Configure -> Configuration
   * Select SmartProxy in Server Roles, Server Control section
   * Click Save
* Add configuration files to default host profile:
   * Go to Configure -> Configuration
   * Click on host default in Analysis profiles on the left side bar
   * Add configuration files that you want to analyze:
      * ex: /etc/\*/\*.conf, /etc/\*/\*.ini
* Enable host fleecing with the heat-admin user:
   * Go to undercloud node
   * Get the private key from /home/stack/.ssh/id_rsa
   * In the ‘RSA KEY pair tab’ of Infra provider add heat-admin User ID and the private file from step 2
* Enable host fleecing with the root user:
   * Go to undercloud node
   * Get the private key from /home/stack/.ssh/id_rsa
   * Switch to the stack user
      * su - stack
   * Get the IP addresses of overcloud nodes
      * . stackrc
      * nova list
   * Connect to each overcloud nodes by using heat-admin user
      * ex: ssh heat-admin@192.0.2.8
   * Switch to root user
      * sudo -i
   * Edit .ssh/authorized_keys to allow regular login
      * sed -i 's/no-port-forwarding.*10" //' .ssh/authorized_keys
   * In the ‘RSA KEY pair tab’ of Infra provider add root User ID and the private file from step 2

##### Add Alert and Event for Auto-Acaling through Automate (Optional)

To enable auto-scaling, follow [the instructions in the ManageIQ depot](http://manageiq.org/depot/extension/openstack_infrastructure_auto_scale/).
