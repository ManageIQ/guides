## Trigger a single Automation Request

*In the automation requests*:

- version defaults to "1.1" if not specified.
- user_name defaults to the REST API authenticated user if not specified.

```
POST /api/automation_requests
```

```json
{
  "version" : "1.1",
  "uri_parts" : {
    "namespace" : "System",
    "class" : "Request",
    "instance" : "InspectME",
    "message" : "create"
  },
  "parameters" : {
    "var1" : "xxxxx",
    "var2" : "yyyyy",
    "var3" : 1024,
    "var4" : true,
    "var5" : "last value"
  },
  "requester" : {
    "user_name" : "jdoe",
    "auto_approve" : true
  }
}
```

Optionally, the action based request format is also supported:

```
POST /api/automation_requests
```

```json
{
  "action" : "create",
  "resource" : {
    "version" : "1.1",
    "uri_parts" : {
      "namespace" : "System",
      "class" : "Request",
      "instance" : "InspectME",
      "message" : "create"
    },
    "parameters" : {
      "var1" : "xxxxx",
      "var2" : "yyyyy",
      "var3" : 1024,
      "var4" : true,
      "var5" : "last value"
    },
    "requester" : {
      "user_name" : "jdoe",
      "auto_approve" : true
    }
  }
}
```

Back to [Reference Guide](../reference.md)
