## Running the test suites

ManageIQ specs are split into several components:

* **vmdb**
* **automation**
* **migrations**
* **providers**
* **replication**
* **javascript**
* **brakeman**

Each suite has a pair of Rake tasks to setup and run them, in the form of `test:<type>` and
`test:<type>:setup` (if required):

```bash
rake test:vmdb:setup             # Setup environment for vmdb specs
rake test:vmdb                   # Run all specs except migrations, replication, and automation
rake test:automation:setup       # Setup environment for automation specs
rake test:automation             # Run all automation specs
rake test:migrations:setup       # Setup environment for migration specs
rake test:migrations             # Run all migration specs
rake test:providers:amazon       # Run all Amazon provider specs
rake test:providers:amazon:setup # Setup environment for Amazon provider specs
rake test:replication:setup      # Setup environment for replication specs
rake test:replication            # Run all replication specs
rake test:javascript:setup       # Setup environment for javascript specs
rake test:javascript             # Run all javascript specs
rake test:brakeman               # Run Brakeman
```
