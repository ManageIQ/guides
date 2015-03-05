## CloudForms OpenStack Infrastructure Provider

The OpenStack infrastructure provider is designed to work with a [TripleO-based OpenStack deployment](https://wiki.openstack.org/wiki/TripleO).  It provides visibility and management capabilities for the undercloud.

### Features

* Host collection through the OpenStack Ironic API
* Host metrics gathered through OpenStack Ceilometer
* Image collection through the OpenStack Glance API

### In Development

* Knowledge of host provisioning (compute, control, storage) through OpenStack Heat and Tuskar APIs
* Additional data collection
   * through OpenStack APIs (Neutron, Nova, etc)
   * through a node's IPMI credentials
   * through Nova SSH keypairs
* Allow scaling of the overcloud through CFME
   * enable this function through both the UI and Automate
* Monitoring of overcloud metrics
* Tighter integration with existing CFME capabilities
   * reporting
   * compliance
   * governance

### Installation

##### Installing a TripleO-based OpenStack deployment

The recommended way to do this is to use Instack: https://openstack.redhat.com/Deploying_RDO_using_Instack

Afterwards, you'll need to expose the undercloud's API endpoints: https://wiki.openstack.org/wiki/Tuskar/Instack#Connecting_to_Undercloud_from_external_place_.28e.g._your_laptop.29

##### Install CloudForms

* https://github.com/ManageIQ/guides/blob/master/developer_setup.md
* https://github.com/ManageIQ/guides/blob/master/developer_ruby2_setup.md

##### Add the TripleO-based OpenStack deployment to CloudForms

After logging into the CFME UI, select 'Infrastructure > Providers' from the top navigation.  Then, under 'Configuration' select 'Add a New Infrastructure Provider'.

In the resulting form, choose 'OpenStack Infrastructure' as the Type.  Fill in the 'Basic Information' and 'Credentials' form.  Note that the IP Address must match the IP shown when running 'keystone endpoint-list' in the undercloud.