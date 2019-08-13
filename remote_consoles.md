### Remote Consoles

Remote consoles allow you to access the screen of a VM through the browser. Each supported protocol has a its own Javascript client and they all connect to a common WebSocket endpoint. This endpoint is provided by the Rails application under `/ws/console` and in production it's being served by the `RemoteConsoleWorker`. This worker runs a [`RemoteConsole::RackServer`](https://github.com/ManageIQ/manageiq/blob/master/lib/remote_console/rack_server.rb) middleware as a web server and it's responsible for proxying and translating between the remote console endpoint and the incoming WebSocket connections.

The server can also be mounted into the development setup of Rails by setting the `MOUNT_REMOTE_CONSOLE_PROXY` environment variable:
```sh
MOUNT_REMOTE_CONSOLE_PROXY=1 bin/rails server
```

The proxy is implemented using an event loop and the [surro-gate](https://github.com/skateman/surro-gate) gem as the selector for testing the readiness of socket pairs. The translation is done using adapters that are available as subclasses of [`RemoteConsole::ServerAdapter`](https://github.com/ManageIQ/manageiq/blob/master/lib/remote_console/server_adapter.rb) for WebSocket and [`RemoteConsole::ClientAdapter`](https://github.com/ManageIQ/manageiq/blob/master/lib/remote_console/client_adapter.rb) for the client protocols. Implementing a new protocol requires to create a new subclass in and update the `.new` method in the related adapter to be able to select it based on the passed context.

The VNC and SPICE consoles are supported out of the box and there is also support for WebMKS. However, due to licensing problems we are not allowed to ship the WebMKS assets. They can be retrieved from the VMware website after accepting the license agreement. Pasting the `webmks` folder with all the assets into the `public` folder in the core repo automatically enables the support for this console type.
