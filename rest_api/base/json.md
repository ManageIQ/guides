## JSON Specification

### General Conventions

The API uses [JSON](http://www.json.org) throughout; the
[Content-Type](http://www.w3.org/Protocols/rfc1341/4_Content-Type.html) for all
requests and responses is `application/json`.

As is general practice with REST, clients should not make assumptions about the
server's URL space. Clients are expected to discover all URL's by navigating the
API. To keep this document readable, we still mention specific URL's, generally
in the form of an absolute path. Clients should not use these, or assume that
the actual URL structure follows these examples, and instead use discovered
URL's. Any client should start its discovery with the API entry point,
here denoted with `/api`.

* [Basic Types](#basictypes)
* [Common Attributes and Actions](#commonattributesandactions)
* [Collections](#collections)
* [Action Specification](#actionspecification)
* [Forms](#forms)

Back to [Design Specification](../design.md)

Back to [JSON Specification](#jsonspecification)

----

### Basic types

The following are basic data types and type combinators that are used throughout:

| Name          | Explanation                                    | Example serialization                           |
|:--------------|:-----------------------------------------------|:------------------------------------------------|
| `String`      | JSON string                                    | `{ "state" : "running" }`                       |
| `URL`         | Absolute URL                                   | `{ "href" : "http://SERVER/vms/1/start" }`      |
| `Timestamp`   | Timestamp in ISO8601 format                    | `{ "created" : "2013-12-05T08:15:30Z" }`        |
| `Array[T]`    | Array where each entry has type T              | `{ "vms" : [ { "id" : "1" }, { "id" : "2" }] }` |
| `Ref[T]`      | A reference to a T, used to model relations, the T is a valid Resource identifier  | `{ "vm" : { "href" : URL } }` |
| `Collection`  | Array[T] where T represents a Ref[T], this might allow actions to be executed on all members as a single unit | `{ "vms" : { "count" : "2", "resources" : [ { "href" : URL}, { "href" : URL } ], "actions" : [] }`|
| `Struct`      | A structure with sub-attributes                | `"power_state": {"state": "ON", "last_boot_time": "2013-05-29T15:28Z","state_change_time":"2013-05-29T15:28Z"}` |

----
Back to [JSON Specification](#jsonspecification)


### Common Attributes and Actions

The following describes attributes and actions that are shared by all
resources and collections defined in this API.

#### Attributes

| Attribute     | Type          | Description                        |
| ------------- |---------------| -----------------------------------|
| id            | Ref(self)     | A unique self reference            |
| name          | String        | A human name of the resource       |


```json
{
  "id" : "http://localhost:3000/api/resources/1",
  "name" : "first_resource"
}
```
#### Actions

| Action        | HTTP method    | Description                         |
| ------------- |----------------| ------------------------------------|
| add           | POST           | Add new resource to the collection  |
| edit          | PUT/PATCH/POST | Edit attributes in resource         |
| delete        | DELETE         | Delete resource                     |

**Note about permissions and security:**

Advertising of the common actions depends purely on the role and permissions
of that the current API user does have for the particular resource.

----
Back to [JSON Specification](#jsonspecification)


### Collections

Resources can be grouped into collections. Each collection is homogeneous so
that it contains only one type of resource, and unordered. Resources can also
exist outside any collection. In this case, we refer to these resources as
singleton resources. Collections are themselves resources as well.

Collections can exist globally, at the top level of an API, but can also be
contained inside a single resource. In the latter case, we refer to these
collections as sub-collections. Sub-collections are usually used to express some
kind of “contained in” relationship

Collections are serialized in JSON in the following way:

```json
{
  "id" : Ref(self),
  "count": String,
  "subcount": String,
  "resources": [ ... ],
  "actions": [ ... ]
}
```

Where the `id` attribute is basically an URL to the collection itself.  The
`count` attribute in a collection always denotes the total number of items in the
collection, not the number of items returned. `subcount` attribute in a collection
depicts the number of items returned.
Then the `resources` attribute is an Array[T] where T might be a list of
references to the T or, if expanded a list of resources with all attributes.
The `actions` then contains an Array of actions that can be performed against
the collection resources.

----
Back to [JSON Specification](#jsonspecification)


### Action Specification

The representation of each resource will only contain an action and its URL
if the current user is presently allowed to perform that action against that
resource. Actions will be contained in the *actions* attribute of a
resource; that attribute contains an array of action definition, where each
action definition has a rel, method and a href attribute.

* *name* attribute contains the action name
* *method* attribute states the HTTP method that must be used in a client
  HTTP request in order to perform the given action
  (eg. GET, POST, PUT, DELETE)
* *href* attribute contains the absolute URL that the HTTP request should
  be performed against
* *form* an optional attribute that references a JSON document which describes
  the resource attributes that can be provided in the message body when performing
  this action. This description will indicate which of those attributes are mandatory
  and which are optional.

#### Collection actions

The actions performed against a collection of resources, are in most cases
batch operations against multiple resources. The action request must include an
HTTP body with the action name and the list of resource representations that the
action will be performed against.

The resource representation might include the resource attributes as they can
change the way how the action is actually performed. In the example below, the
first resource is started with *enable_ipmi* attribute, but the second resource
omits this attribute which means the default value will be used.

Sample JSON request body for collection action:

`POST /api/vms`

```json
{
  "action": "start",
  "resources" : [
    { "href" : "http://localhost:3000/api/vms/1", "enable_ipmi" : "enabled", "initial_state" : "started" },
    { "href" : "http://localhost:3000/api/vms/2" }
  ]
}
```

Actions in collection:

```json
{
  "id" : Ref(self),
  "count": String,
  "resources": [ ... ],
  "actions": [
    {
      "name"   : "shutdown",
      "method" : "post",
      "href"   : URL
    },
    {
      "name"   : "restart",
      "method" : "post",
      "href"   : URL
    },
    {
      "name"   : "poweron",
      "method" : "post",
      "href"   : URL
    },
    {
      "name"   : "poweroff",
      "method" : "post",
      "href"   : URL
    },
    {
      "name"   : "suspend",
      "method" : "post",
      "href"   : URL
    },
    {
      "name"    : "edit",
      "method" : "post",
      "form"   : { "href" : "http://localhost:3000/api/vms?form_for=add" },
      "href"   : URL
    },
    {
      "name"   : "destroy",
      "method" : "delete",
      "href"   : URL
    }
  ]
}
```


#### Resource actions

An action performed against a given resource is always described in the
body of the HTTP request. The HTTP body could contain a list of resource
attributes that dictate how the state of the receiving resource is to be
changed once the action is performed. At minimum the JSON document in the
message body must contain the name of the action to be performed.

In cases where no attributes are required to perform an action the HTTP body
will contain an empty JSON document, in which case default values will be assigned
to the corresponding attributes.

Sample JSON request body for resource action:

`POST /api/vms/123`

```json
{
  "action"   : "start",
  "resource" : { "enable_ipmi" : "enabled" }
}
```


`POST /api/vms/321`

```json
{
  "action"   : "start",
  "resource" : {}
}
```

Actions in a resource:

```json
{
  "id"    : Ref(self),
  "name"  : "resource human name",
  "actions" : [
    {
      "name"   : "edit",
      "method" : "post",
      "form"   : { "href" : "http://localhost:3000/api/vms?form_for=edit" },
      "href"   : URL
    }
  ]
}
```
----
Back to [JSON Specification](#jsonspecification)

### Forms

#### Getting a form

The URL to fetch the form is part of the `action` serialization.
In case when no form is referenced, then the action does not require any
attributes to be performed.

Resource including an action with a Form

```json
{
  "id"    : Ref(self),
  "name"  : "resource human name",
  "actions" : [
    {
      "name    : "edit",
      "method" : "post",
      "form"   : { "href" : "http://localhost:3000/vms?form_for=edit" },
      "href"   : URL
    }
  ]
}
```

```
GET /api/vms?form_for=edit HTTP/1.1
```

Example of a Form:

```json
{
  "required" : [ "name", "host" ],
  "optional" : [ "description" ]
  "internal" : [ "power_state", "created_on"]
}
```

The following describes the semantics of the attribute identifiers:

* required - These attributes must be specified for the action to be carried out.
* optional - These are optional attributes, may be specified and processed by the action.
  So these may be shown in a UI but not enforced.
* internal - It is not necessary to define these, but essential if a UI form may want to show
  and extended form with more attributes than the required/optional to edit. This identifier
  shows what attributes are system managed and not modifiable by the REST client.

----
Back to [JSON Specification](#jsonspecification)


Back to [Design Specification](../design.md)
