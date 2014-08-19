1. Define openstack tenants

    Openstack Tenants, also described as "Projects" in Openstack, isolate cloud resources and users.  Tenant administrators can configure individual quotas per tenant.

2. Collecting tenant details (EMS_Refresh)
  - allow api authentication per tenant (reconnect for each tenant where necessary)
    - hopefully this only applies to collecting quota information (see next point), otherwise this may require tweaking the ems_refresh flow
  - tenant discovery
    - when a new tenant is found, ManageIQ may not have credentials to that tenant if the EMS Admin is not also the tenant admin
      - store the tenant details (name, description)
      - attempt to authenticate 
2. Collecting quota information (EMS_Refresh)
  - [openstack quota cli info](http://docs.openstack.org/user-guide-admin/content/cli_set_quotas.html)
  - has to be collected for individual services
    - nova (compute)
    - cinder (block storage)
    - neutron (network)
  - modeling quota details
    - probably three fields
      - `service` (or, `service_type`)
      - `quota_type` (e.g., cpu [nova], gigabytes [cinder], ports [neutron])
      - `value`
3. Tenant crud (actually, probably view only for now except for credential details)
  - show tenant details
    - name
    - description
    - id? (openstack uuid)
  - admin credentials (optional -- fallback to EMS credentials -- UI Note required)
  - display quota details for different services
    - compute quota available
    - block storage quota available (do we do anything with this yet?)
    - network quota available
4. RBAC
  - control access to tenants via RBAC
5. Provisioning
  - present tenant selection
  - show quota details for selected tenant
6. C&U
  - dual pass rollup
    - VM rolls up to Tenant
    - VM rolls up to AZ
7. Reporting and Tenants