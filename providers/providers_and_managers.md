# What are Providers and Managers?

The terms Provider, Manager, and EMS are all used to some degree interchangeably within the ManageIQ Community however they do have more specific meanings.

### ExtManagementSystem / Manager

Managers represent a grouping of resources by functional classification, e.g.: Cloud, Network, Storage.  For example the `CloudManager` has `vms` and `images`, the `NetworkManager` has `cloud_networks` and `security_groups`, and the `StorageManager` has `cloud_volumes` and `cloud_volume_snapshots`.  This allows for better grouping of related resources.  The managers represent the different "families" of inventory, if a completely new type of manager were brought to ManageIQ we would add a new manager class to represent it.

The current list of manager types:
* AutomationManager
* CloudManager
* ConfigurationManager
* ContainerManager
* InfraManager
* MonitoringManager
* NetworkManager
* PhysicalInfraManager
* ProvisioningManager
* StorageManager

### Provider

A provider is a collection of managers that make up a single "instance" of a management system, e.g. a single OpenShift cluster or AWS account.

This allows for providers to mix-and-match the types of managers that the provider supports, e.g. AWS has Cloud, Network, and Storage where GCE only has Cloud and Network.  Also some providers only bring a single manager such as Nuage or NSX-T which are standalone Network Managers.

This also allows for endpoints and credentials to be either:

1. Shared across all of the managers e.g. AWS all services can be accessed with one set of credentials
2. Different for different managers e.g. OpenShift ContainerManager and InfraManager (aka KubeVirt) have different endpoints

This can be accomplished by specific providers either delegating from the manager to the provider or defining endpoints and authentications on the individual managers.
