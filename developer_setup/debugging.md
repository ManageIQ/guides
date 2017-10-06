## Debugging ManageIQ with Remote Pry

Interactive debugging using pry or byebug is normally difficult with ManageIQ, as `rake evm:start` launches the server and worker processes in the background. Therefore the only way to do interactive debugging is with `pry-remote` or `byebug` running in remote mode.

Running ManageIQ with `byebug` was exceedingly slow, so this guide will focus on remote debugging using `pry`.

### Adding dependencies

You'll need to add the following gems to your dev overrides file in `bundler.d/`:

```ruby
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-nav'
```

### Starting the debugger

Setting a breakpoint with `pry` requires adding the following line somewhere in your code:

```ruby
#code executes until this line
binding.remote_pry
#code here does not execute
```

When execution reaches the `remote_pry` call, the line  `pry-remote] Waiting for client on drb://localhost:9876` will print to STDOUT (stderr?) and execution will block until you connect the client debug process.

To connect the debugger, simply run from the ManageIQ root dir:
```
bundle exec pry-remote
```
which will attempt to connect to the pry server on port 9876.

With the addition of `pry-nav`, you'll have access to commands `continue`, `step`, and `next`, to navigate through your code.

### Notes

Setting breakpoints from within pry is currently not possible with `pry-nav`. As a workaround, it's possible to set conditional breakpoints throughout your code like so:

```ruby

binding.remote_pry

# do some stuff

if @breakpoint_enabled
  binding.remote_pry
end
```

And simply set `@breakpoint_enabled = true` when you reach your first breakpoint to enable the next breakpoint to trigger.

Note that you will have to `continue` to exit out of `pry` and then `bundle exec pry-remote` again to enter into subsequent breakpoints in the same process.
