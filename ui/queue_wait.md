### Running through the Queue and Busy Waiting

General usecase for the UI is to display information from the database and queue
request to the database.

The state in the database is maintained by workers in addition to various tasks that
are queued are handled by various workers.

The UI calls methods on models or services, those methods queue tasks
that are then acted on by the workers. The workers update the database. Later
the UI can see the updated state.

Example: If we power off a VM we really don't do the API call to RHEV or EC2 or
VMware straight. Instead we queue such action and display a flash message
or notification saying that the task was queued.

Later the UI will see the updated state in the database (the VM will be down).

In some cases however it is necessary to wait for the result of such task. The
task still cannot be done directly as the Appliance running the UI might not be
even able to reach the API endpoint of the underlying provider.

Examples of this might be:
 * verifying credentials when adding a provider,
 * opening a remote console to a VM.

In such cases we have the `wait\_for\_task` call.

Example in `create` we do a call that returns a `task\_id`. Then we call `initiate\_wait\_for\_task`.

```
def create
  ...

  task_id = CloudTenant.create_cloud_tenant_queue(session[:userid], ems, options)

  add_flash(_("Cloud tenant creation failed: Task start failed: ID [%{id}]") %
            {:id => task_id.inspect}, :error) unless task_id.kind_of?(Fixnum)

  if @flash_array
    javascript_flash(:spinner_off => true)
  else
    initiate_wait_for_task(:task_id => task_id, :action => "create_finished")
  end
end
```

This results in a transaction that fired busy waiting in the browser and polling `ApplicationController::wait\_for\_task`.

When the task is finished, the `:action` passed in is called with the original parameters passed to the `create` call plus the task\_id.

```
  def create_finished
    task_id = session[:async][:params][:task_id]
    tenant_name = session[:async][:params][:name]
    task = MiqTask.find(task_id)
    if MiqTask.status_ok?(task.status)
      add_flash(_("%{model} \"%{name}\" created") % {
                  :model => ui_lookup(:table => 'cloud_tenant'),
                  :name  => tenant_name
                })
    else
        add_flash(_("Unable to create %{model} \"%{name}\": %{details}") % {
                    :model   => ui_lookup(:table => 'cloud_tenant'),
                    :name    => tenant_name,
                    :details => task.message
                  }, :error)
    end

    @breadcrumbs.pop if @breadcrumbs
    session[:edit] = nil
    session[:flash_msgs] = @flash_array.dup if @flash_array

    javascript_redirect :action => "show_list"
  end
```
