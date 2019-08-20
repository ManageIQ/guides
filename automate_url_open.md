### Opening custom URLs via Custom Buttons and Automate

For a number of different entities users can create custom [toolbar
buttons](ui/toolbars.md) that run an automate method on the particular entity,
let that automate method calculate a URL and then have the UI open such URL in
a new window.

#### Steps

Create custom button with Automate method:

1) Automation -> Automate -> Explorer:

   a) create a new domain with a name

   b) select ManageIQ/System/Request

   c) Configuration -> Copy this Class (copy it to your new domain from step 1a)

   d) select Request Class in your new domain -> Configuration -> Add a new Instance
      * name `TestOpenUrl`
      * to `meth1` write `test_open_url`

   e) Select Request class in your new domain, click Methods -> Configuration -> Add a new Method
      * type: inline
      * name: test_open_url
      * data should be (or anything that sets `vm.external_url` to something):

![Create Automate Method](images/automate_url_open.png?raw=true "Create Automate Method")

```
      vm = $evm.root['vm']
      $evm.log(:info, "VM to launch SSH for is #{vm.hostnames[0]}")
      vm.external_url = "https://www.google.com"

```
*important: use URL including the protocol (https) or the browser will ignore the request*

*also disable URL pop-up blocking in your browser to make this work*

Automation -> Automate -> Customization -> Buttons

Create a new button for VMs with "Open Url" checked and either w/ or w/o a "Dialog" and "Request" has to be `TestOpenUrl`

Go to VM summary page and click the new button.

After clicking the button or after submitting the dialog (if you selected one) you will be redirected to VM summary page and a new page will open in a new browser tab.

#### Example automate code for User

```
$evm.log(:info, "Current user_id #{$evm.root['user_id']}")
object = $evm.vmdb($evm.root['vmdb_object_type']).find_by(:id => $evm.root['user_id'])
$evm.log(:info, "Current object #{object}")
object.external_url = "https://www.linkedin.com"
```

