
### HTTP Basics

1. [REST Entry Point](#restapientrypoint)
1. [Supported Content Types](#supportedcontenttypes)
1. [URL Paths](#urlpaths)
1. [Methods and related URLs](#methodsandrelatedurls)
1. [Updating resources](#updatingresources)
1. [Return Codes](#returncodes)

Back to [Design Specification](../design.md)

----

#### REST API entry Point

The REST API is made available via the /api URL prefix. It can be accessed on the Appliance server directly via HTTP using the default port as follows:

```
http://localhost:3000/api
```

Or external to the Appliance as follows:

```
https://<applianceHost_fqdn>/api
```

`Response`

```json
{
  "id" : "http://localhost:3000/api",
  "name" : "REST API",
  "version" : "1.0",
  "versions" : [
    {
      "name" : "1.0",
      "href" : "http://localhost:3000/api/v1.0"
    },
    {
      "name" : "0.5",
      "href" : "http://localhost:3000/api/v0.5"
    },
    {
      "name" : "0.1",
      "href" : "http://localhost:3000/api/v0.1"
    }
  ]
  "collections" : [
    {
      "name" : "providers",
      "href" : "http://localhost:3000/api/providers",
      "description" : "Extended Management Systems"
    },
    {
      "name" : "vms",
      "href" : "http://localhost:3000/api/vms",
      "description" : "Virtual Machines"
    },
    ...
  ]
}
```

* Version is the Current API version, accessible via either of the following:
  * /api/
  * /api/v1.0/


* Versions lists all the earlier API versions that are still exposed via their respective entry points:
  * /api/v`Version`/


----

#### Supported Content Types

Requests:

```
Accept: application/json
```

Responses:

```
Content-Type: application/json
```

----

#### URL Paths

The recommended convention for URLs is to use alternate collection / resource
path segments, relative to the API entry point as described in the following example:

| URL | Description |
|-----|-------------|
| /api | The REST API Entrypoint |
| /api/v`Version` | The REST Entrypoint for a specific version of the REST API |
| /api/:collection | A top-level collection |
| /api/:collection/:id | A specific resource of that collection |
| /api/:collection/:id/:subcollection | Sub-collection under the specific resource |

#### Methods and related URLs

The basic HTTP Methods used for the API are GET, POST, PUT, PATCH and DELETE.


| URL | Semantic |
| --- | -------- |
| GET /api/:collection | Return all resources of the collection |
| GET /api/:collection/:id | Return the specific resource |
| POST /api/:collection | Create a resource in the collection |
| POST /api/:collection/:id | Perform an Action on a resource in the collection |
| PUT /api/:collection/:id | Update a specific resource |
| PATCH /api/:collection/:id | Update a specific resource |
| DELETE /api/:collection/:id | Delete a specific resource |

There :collection represent specific Appliance entities like services, hosts, vms, etc.


----

#### Updating resources

As shown in the above table, there are a couple of way to update attributes in a resource. These are:
* Update a resource via the PUT HTTP Method
* Update a resource via a POST Method with an *edit* action.
* Update a resource via the PATCH HTTP Method

While the PUT is the common method, the PATCH mechanism gives better control
on which attribute to edit, add as well as remove which is not available with
the other two methods.


##### Modifying Resource attributes

`PUT /api/vms/42`

```json
{
  "name" : "A new VM name",
  "description" : "A Description for the new VM"
}
```

`POST /api/vms/42`

```json
{
  "action" : "edit",
  "resource" : {
    "name" : "A new VM name",
    "description" : "A Description for the new VM"
  }
}
```

`PATCH /api/vms/42`

```json
[
  { "action": "edit", "path": "name", "value": "A new VM name" },
  { "action": "add", "path": "description", "value": "A Description for the new VM" },
  { "action": "remove", "path": "policies/3/description" }
]
```

In the PATCH implementation, path either references local attributes or
attributes from a related resource in a subcollection.

----

#### [Return Codes](id:returncodes)

* [Success](#success)
* [Client Errors](#clienterrors)
* [Server Errors](#servererrors)


##### [Success](id:success)

* **200 OK** -
  The request has succeeded without errors, this code should be returned for
  example when retrieving a collection or a single resource.

* **201 Created** -
  The request has been fulfilled and resulted in a **new resource being created**.
  The resource is available before this status code is
  returned. The response includes the HTTP body of the newly created resource.

* **202 Accepted** -
  The request has been accepted for processing, but the processing has not been
  completed. Like, resource is not fully available yet. This status code is
  usually returned when the resource creation happens asynchronously. In this case
  the HTTP response includes a pointer to *monitor* or a *job* where the
  client can query to get the current status of the request and the estimate on
  when the request will be actually fulfilled.

* **204 No Content** -
  The server has fulfilled the request but does not need to return an
  entity-body, and might want to return updated meta information.
  This HTTP response is commonly used for the DELETE requests, as the resource
  that was deleted does not exists anymore.


##### [Client Errors](id:clienterrors)

* **400 Bad Request** -
  The request could not be understood by the server due to malformed syntax. The
  client SHOULD NOT repeat the request without modifications. In REST API this
  status code should be returned to client when the client use the wrong
  combination of attributes, like expanding the non-existing collection, or using
  the pagination parameter incorrectly.  Another use-case could be creating or
  performing actions on the resource, when the wrong JSON serialization of the
  resource or action is used.

* **401 Unauthorized** -
  The request requires user authentication. The response MUST include a
  *Authenticate* header field containing a challenge applicable to the requested
  resource. If the request include *Authenticate* header, then this HTTP status
  code might indicate that the current user is **not authorized** to perform given
  action or to access given resource.

* **403 Forbidden** -
  The server understood the request, but is refusing to
  fulfill it. Authorization will not help in this case. This HTTP status code
  might indicate that the action performed is not supported for this resource or
  collection.

* **404 Not Found** -
  In this case, the server has not found anything that matches with the URL.

* **415 Unsupported Media Type** -
  The server is refusing to service the request because the entity of the
  request is in a format not supported by the requested resource for the requested
  method. This error must be returned, when the client is explicitly asking for
  format other than JSON (application/json).

##### [Server Errors](id:servererrors)


* **500 Internal Server Error** -
  The server encountered an unexpected condition which prevented it from
  fulfilling the request. This error code must be used when an exception is
  raised in the application and the exception has nothing to do with the client
  request.


Back to [Design Specification](../design.md)
