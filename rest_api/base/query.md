## Query Specification

This specification identifies the controls available when querying collections.

The controls are specified in the GET URL as attribute value pairs as follows:

```
GET /api/resources?ctl1=val1&ctl2=val2&..
```

### Control Attributes

| Category | Attribute | Semantics |
| -------- | --------- | --------- |
| Paging | | |
| | offset | 0-based offset of first item to return |
| | limit | number of items to return. If 0 is specified then the remaining items are returned |
| Scope | | |
| | sqlfilter | String specifying the SQL filter to search on. See [Filtering](#filtering) below. |
| | attributes=atr1,atr2,... | Which attributes in addition to id to return. If not specified or all (default is attributes=all), then all attributes are returned |
| | expand=resources | To expand the resources returned in the collection and not just the href. See [Expanding Collection](#expandingcollection) below |
| Sorting | | |
| | sort_by=atr1,atr2,... | By which attribute(s) to sort the result by |
| | sort_order=ascending or descending | Order of the sort |

* The `count` attribute in a collection always denotes the total number of items
in the collection, not the number of items returned.

* The `subcount` attribute in a collection denotes the number of items from the
collection that were returned. For example, as a result of a paged request.

----

#### Filtering

`GET` requests against collections support the following query parameters to enable filtering:


* `sqlfilter`: The SQL filter to use for querying the collection, i.e. sqlfilter="name LIKE 'myservice%' ".


```
GET /api/resources?sqlfilter=name LIKE 'myservice%'
```

----

## Expanding Collection

While in the JSON serialization example the description says that the resource
might be a list of references to these resource, using the `expand` parameter
they can be expanded to return a full JSON serialization of the resource
instead:

**GET** */api/vms*

```json
{
  "id" : "http://localhost:3000/api/vms"
  "count": "2",
  "resources": [
    { "href" : "http://localhost:3000/api/vms/1" },
    { "href" : "http://localhost:3000/api/vms/2" }
  ],
  "actions": []
}
```

**GET** */api/vms?expand=resources*

```json
{
  "id" : "http://localhost:3000/api/vms"
  "count": "2",
  "resources": [
    {
      "id" : "http://localhost:3000/api/vms/1",
      "name" : "My First VM",
      ...
    },
    {
      "id" : "http://localhost:3000/api/vms/2",
      "name" : "My Second VM",
      ...
    }
  ],
  "actions": []
}
```

----
Back to [Design Specification](../design.md)
