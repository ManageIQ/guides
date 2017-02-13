## ManageIQ Hawkular (middleware) Provider

If you wish to run locally Hawkular provider and don't want to set things up, we have easy to run tool called [Hawkinit tool](https://github.com/Jiri-Kremser/hawkinit).
It's interactive command line tool which uses docker.

For Requirements follow [Hawkinit requirements](https://github.com/Jiri-Kremser/hawkinit#requirements).

### Running Hawkular with Hawkinit tool
Install globally trough NPM [Hawkinit](https://www.npmjs.com/package/hawkinit)

```npm install hawkinit -g```

There are two options how to run hawkinit:
 1. Answer questions from tool
  * Version of hawkular
  * Version of Cassandra
  * Number of cassandra nodes
  * WildFly servers types (Standalone or Domain [[1](#domain-standalone)])
     * Standalone - Each WF server as independent process
       * WildFly version
       * Number of WildFly servers
     * Domain - Multiple servers managed from single point
       * Version of domain WF
       * Number of host controllers (1  is always the domain controller and others are host controllers)
       * Scenario to pick [scenarios](https://github.com/Jiri-Kremser/hawkfly-domain-dockerfiles)

 For basic usage, you don't have to change anything (Hawkinit has some basic preselected answers).
 2. If you want to keep your changes from ``1. step`` you can run

 ```hawkinit -s```

 This will save your answers in file `answers.json` in your current location, ```PATH_TO_ANSWERS=/home/me/Documents/answers.json```. To run **Hawkinit** with these options
 without need to answer to tool's questions you can pass this file:

 ```hawkinit -a $PATH_TO_ANSWERS```

 Answers files examples:

 Standalone with one WildFly Server
 ```json
 {
  "hawkVersion": "latest",
  "cassandraVersion": "3.0.9",
  "cassandraCount": 1,
  "wfType": "Standalone",
  "wfStandaloneVersion": "0.24.1",
  "wfStandaloneCount": 1
}
 ```

 Standalone with 5 WildFly Servers
 ```json
 {
  "hawkVersion": "latest",
  "cassandraVersion": "3.0.9",
  "cassandraCount": 1,
  "wfType": "Standalone",
  "wfStandaloneVersion": "0.24.1",
  "wfStandaloneCount": 5
}
 ```

 Domain with 1 host controller and simple scenario
 ```json
 {
  "hawkVersion": "0.30.0.Final",
  "cassandraVersion": "3.0.9",
  "cassandraCount": 1,
  "wfType": "Domain",
  "wfDomainVersion": "0.24.1",
  "hostControllerCount": 1,
  "domainScenario": "simple"
}

 ```

### Accessing Hawkular
After **Hawkinit** tool will download, install and run docker images, wait couple of minutes before all services are up
and running. Then the server will run on `localhost:8080` (if you have multiple localhost's registered in MiQ you can
use `127.0.0.x` x=1-255).

Password and login is `jdoe:password`.

If you want to run curl/postman/check from browser you need to have `Hawkular-Tenant: Hawkular` header set up.
Example of Curl (Fetch all metric gauges):
```bash
curl -X GET -H "Content-Type: application/json" \
-H "Hawkular-Tenant: hawkular" \
-H "Accept: application/json" \
-H "Authorization: Basic amRvZTpwYXNzd29yZA==" \
"http://127.0.0.1:8080/hawkular/metrics/gauges"
```

 [1] <a name="domain-standalone" href="https://docs.jboss.org/author/display/WFLY8/Getting+Started+Guide">
   https://docs.jboss.org/author/display/WFLY8/Getting+Started+Guide
</a>
