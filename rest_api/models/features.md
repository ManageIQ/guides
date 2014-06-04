
### Feature Set

This table presents the Appliance Feature Set, Entities, Components, Classes as well as the related REST API collection and targeted availability in which API Version.



| Feature Set | Entity | Component | Class | REST Collection | API version |
| ----------- | ------ | --------- | ----- | --------------- |:-----------:|
| **Services** | | | | | |
| | Services | | Service | [services](./services.md) | 1.0 |
| | Service Catalogs | | |
| | | Catalog Items | ServiceTemplate | [service_templates](./service_templates.md) | 1.0 |
| | | Catalogs | ServiceTemplateCatalog | [service_catalogs](./service_catalogs.md) | 1.0 |
| | Workloads | | |
| | | VMs & Instances | Vm |
| | | Templates & Images | MiqTemplate |
| | Requests | | MiqRequest |
| **Infrastructure** | | | |
| | Provider | | ExtManagementSystem | [providers](./providers.md) | 1.0 |
| | Cluster | | EmsCluster | [clusters](./clusters.md) | 1.0 |
| | Host | | Host | [hosts](./hosts.md) | 1.0 |
| | VMs & Templates | | VmOrTemplate |
| | | VMs | Vm | [vms](./vms.md)| 1.0 |
| | | Templates | MiqTemplate | [templates](./templates.md) | 1.0 |
| | Resource Pools | | ResourcePool | [resource_pools](./resource_pools.md) | 1.0 |
| | Datastores | | Storage | [data_stores](./data_stores.md) | 1.0 |
| | Repositories | | Repository |
| | PXE Servers | | PxeServer |
| | | Customization Templates | CustomizationTemplate |
| | | System Image Types | PxeImageType |
| | | ISO Datastores | IsoDatastore |
| | Requests | | MiqRequest |
| **Control** | | | |
| | Policy Profiles | | MiqPolicySet | [policy_profiles](./policy_profiles.md) | 1.0 |
| | Policies | | MiqPolicy | [policies](./policies.md) | 1.0 |
| | Events | | MiqEvent |
| | Conditions | | Condition |
| | Actions | | MiqAction |
| | Alert Profiles | | MiqAlertSet |
| | Alerts | | MiqAlert |
| **Automate** | | | |
| Explorer | Datastore |  | MiqAeNamespace MiqAeInstance |
| | | Alert | |
| | | Automation | |
| | | EVMApplications | |
| | | Factory | |
| | | Integration | |
| | | Sample | |
| | | System | |
| Customization |  | | |
| | Provisioning Dialogs | | MiqDialog |
| | Service Dialogs | | Dialog |
| | Buttons | |
| | | Button Groups | CustomButtonSet |
| | | Buttons | CustomButton |
| | Automation Requests | AutomationRequest |
| **Configure** | | | |
| Settings | | | |
| | Zone | | Zone | [zones](./zones.md) | 1.0 |
| | | EVM Server | MiqServer | [servers](./servers.md) | 1.0 |
| | | Schedules | MiqSchedule |
| Access Control | | | |
| | Users | | User | [users](./users.md) | 1.0 |
| | Groups | | MiqGroup | [groups](./groups.md) | 1.0 |
| | Roles | | MiqUserRole | [roles](./roles.md) | 1.0 |

Back to [Design Specification](../design.md)
