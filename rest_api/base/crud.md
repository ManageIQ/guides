
### CRUD Request Examples

The following examples show the basic CRUD operations (Create, Read, Update, Delete) using the REST API.

For Authentication, we are showing here basic authentication via the *--user admin:smartvm* credentials argument. For multiple API calls it is recommended to access the REST API via token based authentication, please refer the the [Authentication Page](./auth.md) for details.


#### Show a collection of Resources

Get a collection of services: **GET /api/services**

```sh
curl --user admin:smartvm
      -i -X GET -H "Accept: application/json"
      http://localhost:3000/api/services
```


#### Return a single Resource

Return a single service: **GET /api/services/:id**

```sh
curl --user admin:smartvm
      -i -X GET -H "Accept: application/json"
      http://localhost:3000/api/services/1
```


#### Create a Resource

Create a new provider: **POST /api/providers**

```sh
curl --user admin:smartvm
      -i -X POST -H "Accept: application/json"
      -d '{
            "name"     : "RHEV Provider",
            "type"     : "rhevm",
            "hostname" : "rhevm.local.com",
            "address"  : "192.168.5.1",
            "port"     : "80",
            "username" : "admin",
            "password" : "12345"
      }'
      http://localhost:3000/api/services
```


#### Update a Resource

Update the email of a user: **PUT /api/users/:id**

```sh
curl --user admin:smartvm
      -i -X PUT -H "Accept: application/json"
      -d '{ "email" : "john.doe@local.com" }'
      http://localhost:3000/api/users/1
```


#### Delete a Resource

Delete a service: **DELETE /api/services/:id**

```sh
curl --user admin:smartvm
      -i -X DELETE -H "Accept: application/json"
      http://localhost:3000/api/services/1
```


Back to [Design Specification](../design.md)
