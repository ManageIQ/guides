The ManageIQ application can run as a collection of worker processes, without a centralized server. As a developer it may be easier to start the worker that you are currently working on, rather than starting the whole server and letting it launch the worker for you.

## run_single_worker.rb

The `run_single_worker.rb` script allows a single worker to be started without needing a server to monitor it. You simply provide the worker class and optionally a queue name and port as environment variables and the worker will start.

There are additional options available which can be seen in the script's usage documentation.

## Foreman

[Foreman](https://ddollar.github.io/foreman/) is a simple process management tool which will start up a group of processes at the same time.
It handles things like spinning up multiple instances of a particular process and even will increment the built in PORT environment variable for each worker and worker type.

### On ports
Foreman's port number handling introduces one big change in that the port assignment is not the same as the default ports for our workers. Foreman increments the port starting number by 100 for each worker type and 1 for each worker instance.

This means that the first worker listed in your Procfile will get port 3000, the second will get port 3100, etc.
For our example Procfile, this means that the UI worker will get port 3000, the API worker will get 3100 and the websocket worker will get 3200. If you need a particular port for a worker, you can still set the environment variable manually in the Procfile.

## Our Procfile

An [example procfile](https://github.com/ManageIQ/manageiq/blob/master/Procfile.example) can be found in the root of the ManageIQ repo. This file illustrates some common ways to start different types of workers, including web server workers, queue workers, and provider based workers.

A developer should create a `Procfile` which suits their particular needs then run `bin/rake evm:foreman:start`. This task will configure the local server to look started and then start the processes in the `Procfile`.

These processes will run in the console in which the rake task was run until the user kills them with a Ctrl-C.

## Additional details

When we start using Foreman, a server process is not started. This has some implications for how the application will work. Most notably, settings will not be refreshed for workers and roles will not be able to be changed at runtime.

If you need a worker to pick up a changed setting or role, just kill the process in the terminal and start the workers back up.
