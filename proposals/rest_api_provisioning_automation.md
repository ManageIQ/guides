## Proposal for Provisioning & Automation REST APIs

This document proposes 2 new REST API collections that complement the Automate Web Services
calls for Provisioning and Automation. These are detailed in the [Integration Services Guide](https://access.redhat.com/documentation/en-US/CloudForms/3.0/html/Management_Engine_5.2_Integration_Services/chap-Automate_Web_Services.html).

**Note:** In this document, \<Rid\> and \<Tid\> represent the SOAP requestId and taskId parameters.

### Proposed REST API for Provisioning

|Request|Description|
|-------|-----------|
|POST /api/provision_requests                        |Create a Provision Request                |
|GET  /api/provision_requests                        |Get all Provision Requests                |
|GET  /api/provision_requests/\<Rid\>                |Get a Provision Request by Id             |
|GET  /api/provision_requests/\<Rid\>/tasks          |Get all Tasks for a Provision Request     |
|GET  /api/provision_requests/\<Rid\>/tasks/\<Tid\>  |Get a Task for a Provision Request by Id  |

**Note:** The /api/provision_requests would be used for both EVMProvisionRequestEx and VmProvisionRequest
SOAP calls.

### Proposed REST API for Automation

|Request|Description|
|-------|-----------|
|POST /api/automation_requests                       |Create an Automation Request              |
|GET  /api/automation_requests                       |Get all Automation Requests               |
|GET  /api/automation_requests/\<Rid\>               |Get an Automation Request by Id           |
|GET  /api/automation_requests/\<Rid\>/tasks         |Get all Tasks for an Automation Requet    |
|GET  /api/automation_requests/\<Rid\>/tasks/\<Tid\> |Get a Task of an Automation Request by Id |


### SOAP Call => REST API Mapping

|SOAP Call  |REST API  |
|-----------|----------|
|CreateAutomationRequest |POST /api/automation_requests                       |
|GetAutomationRequest    |GET  /api/automation_requests/\<Rid\>               |
|                        |or GET  /api/requests/\<Rid\>                       |
|GetAutomationTask       |GET  /api/automation_requests/\<Rid\>/tasks/\<Tid\> |
|                        |or GET  /api/request_tasks/\<Tid\>                  |
|EVMProvisionRequestEx   |POST /api/provision_requests                        |
|VmProvisionRequest      |POST /api/provision_requests                        |
|GetVmProvisionRequest   |GET  /api/provision_requests/\<Rid\>                |
|                        |or GET  /api/requests/\<Rid\>                       |
|GetVmProvisionTask      |GET  /api/provision_requests/\<Rid\>/tasks/\<Tid\>  |
|                        |or GET  /api/request_tasks/\<Tid\>                  |


---
### Sample Provisioning Request:

```http
POST /api/provision_requests
```

```json
{
  "version" : "1.1",
  "template_fields" : {
    "guid" : "afe6e8a0-89fd-11e3-b6ac-b8e85646e742"
  },
  "vm_fields" : {
    "number_of_cpus" : 1,
    "vm_name" : "aab_test_vm1",
    "vm_memory" : 1024,
    "vlan" : "test_vlan1"
  },
  "requester" : {
    "user_name" : "jdoe",       /* Defaults to REST API Request credentials */
    "owner_first_name" : "John",
    "owner_last_name" : "Doe",
    "owner_email" : "john.doe@sample.com",
    "auto_approve" : true
  },
  "tags" : {
    "network_location" : "Internal",
    "cc" : 001
  },
  "additional_values" : {
    "request_id" : 1234
  },
  "ems_custom_attributes" : {
  },
  "miq_custom_attributes" : {
  }
} 
```

---
### Sample Automation Request:

```http
POST /api/automation_requests
```

```json
{
  "version" : "1.1",
  "uri_parts" : {
    "namespace" : "System",
    "class" : "Request",
    "instance" : "super_method",
    "message" : "create"
  }
  "parameters" : {
    "var1" : "xxxxx",
    "var2" : "yyyyy",
    "var3" : "zzzzz"
  }
  "requester" : {
    "user_name" : "jdoe",       /* Defaults to REST API Request credentials */
    "auto_approve" : true
  }
}
```

