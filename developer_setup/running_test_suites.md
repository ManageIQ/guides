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
rake test:providers:amazon:setup # Setup environment for Amazon provider specs
rake test:providers:amazon       # Run all Amazon provider specs
rake test:replication:setup      # Setup environment for replication specs
rake test:replication            # Run all replication specs
rake test:javascript:setup       # Setup environment for javascript specs
rake test:javascript             # Run all javascript specs
rake test:brakeman               # Run Brakeman
```

### Running the vmdb suite in parallel

The main `vmdb` suite of tests can be run in parallel, utilizing multiple
processor cores. These separate processes run concurrently and are then
collected and reported on together when they all complete their delegated work.
You can run the entire vmdb suite or select spec files within it.

#### Setup

Running tests in parallel requires as many different databases as cores you plan to run on.

To set up these databases, simply execute the following command:

```
$ PARALLEL=true bin/rake test:vmdb:setup
```

#### Run the entire suite in parallel

You can run the entire suite in parallel using the following command:

```
$ PARALLEL=true bin/rake test:vmdb
```

#### Passing RSpec options to the rake tasks

RSpec accepts a `SPEC_OPTS` environment variable to pass command line flags.
This is necessary when you wish to use some command line option with our
built-in rake commands to run the tests.

For example, I may wish to set a particular seed and stop running the tests
immediately on a failure:

```
$ PARALLEL=true SPEC_OPTS="--seed 1234 --fail-fast" bin/rake test:vmdb:setup
```

Note that `--fail-fast` will stop whichever core encountered the error, not
every core at the first error found.

#### Running specific spec files in parallel

You needn't run the entire vmdb suite to take advantage of running tests in
parallel. Use `parallel_rspec` to run specific directories of spec files.

For example, I may have done some work on the front end and want to run the
controller, helper, and view specs specifically:

```
$ parallel_rspec spec/controllers spec/helpers spec/views
```

This will run all of the specs in their respective directories, in parallel.
Note you do not need `PARALLEL=true` using `parallel_rspec`.

**Other tips:**

* You can get creative with searching and globbing patterns to feed to the
  `parallel_rspec` command. For example, I might have recently made some pretty
  drastic changes to role checking code having to do with a method named
  `#role_allows`. To quickly run specs that *might* touch this code, I can pass
  in all tests that mention it directly:

  ```
  $ parallel_rspec `git grep -l role_allows spec`
  ```

* Each core requires a certain amount of overhead involved with loading all of
  the application code, etc. Always running the maximum number of cores
  available isn't always beneficial to fast tests. If you're running a subset
  of tests and parallel_tests reports that you're running a very small number
  of specs across each core, try using fewer cores doing more work instead. You
  can specify the number with the `-n` option.  For example, to run all the
  request specs with four cores:

  ```
  $ parallel_rspec -n 4 spec/requests
  ```

* We use the [parallel_tests](https://github.com/grosser/parallel_tests) gem to
  make all of this possible - Go check out the documentation to learn even more
  things you can do with running ManageIQ tests in parallel!

