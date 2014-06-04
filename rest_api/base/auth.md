### REST API Authentication

There are two methods of authentication for the REST API, these are:

* Basic Authentication
* Token based Authentication

With Basic Authentication, the user and password credentials are passed in with each HTTP request as follows:

##### Request using Basic Authentication

```sh
$ curl --user username:password
        -i -X GET -H "Accept: application/json"
        http://localhost:3000/api/services/1013
```


However, for multiple REST API calls to the Appliance, it is recommended to use the Token based Authentication. In this approach, the client requests a token for the username/password credentials specified. Then the token is used in lieu of the username/password for each subsequent API call.

Authentication tokens:

* Are associated with the user credential
* Provide the necessary identify for RBAC in subsequent REST calls
* Expire after a certain amount of time - 10 minutes by default.

#### Requesting an authentication token

##### Request

```sh
$ curl --user username:password
        -i X GET -H "Accept: application/json"
        http://localhost:3000/api/auth
```


##### Response

Response for the Authentication Token Request

```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "auth_token" : "af0245-238722-4d23db",
  "expires_on" : "2013-12-07T18:20:07Z"
}
```

#### Request using Token based authentication

```sh
$ curl -i -X GET -H "Accept: application/json"
       -H "X-Auth-Token: af0245-238722-4d23db"
       http://localhost:3000/api/services/1013
```


##### Failed response due to invalid token

```
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Basic realm="Application"
...
```

When a request fails due to an invalid token, the client would then need to re-authenticate with the user credentials to obtain a new Authentication Token.


Back to [Design Specification](../design.md)
