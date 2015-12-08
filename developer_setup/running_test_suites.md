## Running the test suites

ManageIQ specs are split into several components:

* **vmdb**
* **automation**
* **migrations**
* **replication**
* **javascript**
* **self_service**
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
rake test:replication:setup      # Setup environment for replication specs
rake test:replication            # Run all replication specs
rake test:javascript:setup       # Setup environment for javascript specs
rake test:javascript             # Run all javascript specs
rake test:self_service           # Run all self_service tests; Requires add'l setup (see below)
rake test:brakeman               # Run Brakeman
```

### Self Service UI setup

The Self Service UI tests require additional setup as they use the [Gulp](http://gulpjs.com/) Javascript task runner.

##### Install Node.js

Consult your OS/distribution's package manager to install Node.js. Some common ones:

```bash
# OSX with Homebrew
brew install node

# Fedora/RHEL/CentOS
sudo dnf install nodejs
```

Alternatively, you can also use binaries/installers available from
[nodejs.org](https://nodejs.org/en/download/)

##### Install packages and run the tests

```plaintext
# In ManageIQ directory
cd spa_ui/self_service
npm install
npm test # Or, run the self_service Rake task above
```
