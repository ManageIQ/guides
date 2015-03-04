## MAC Based MIQ Dev/Test Appliance Setup
These instructions outline the process of creating a development MIQ
appliance that will run on a MAC under VMware Fusion.

Through the use of VMware Tools shared folders, the appliance runs MIQ code residing on the MAC.
Code can then be maintained and manipulated on the MAC, and tested directly on the appliance.

### Acquire the needed files
1. Download a [MIQ OVA From manageiq.org](http://manageiq.org/download/manageiq-vsphere-devel.ova) to the MAC.
* On the MAC, in order to obtain the __`miq-dev-appliance-setup`__ collection of scripts,
	clone [manageiq guides](https://github.com/ManageIQ/guides) from GitHub.
	A description of said scripts can be found [here](README.md).

### Create and configure base MIQ VM
1. Start VMware Fusion and create a new VM by importing the MIQ OVA:
	* Select: __`file->import...`__ then __`Choose File...`__
	* Select the OVA file you downloaded from RHN, and then __`open`__.
	* Select: __`Continue`__.
	* Select an appropriate name for the VM, and then __`save`__.
	* Wait for the import to complete. This can take some time.
	* On the __`Finish`__ screen, select __`Customize Settings`__.
		* Add a CD/DVD device, so we can install VMware Tools:
			- Select __`Add Device...`__ then __`CD/DVD Drive`__
			- Set __`Enable CD/DVD Drive`__ to __`Off`__, then __`Add Device...`__
		* Edit the VM's network settings, and set the connection to __`NAT`__.
* Start the VM and login to the console.
* Take note of the VM's IP address.
* Hit __`<return>`__ to get the console menu.
* Select __`Set Hostname`__ and set an appropriate hostname.
* Select __`Set DHCP Network Configuration`__, and __`y`__ to confirm.
* Select __`Shut Down Appliance`__, and __`y`__ to confirm.
* You may want to snapshot the VM at this point.

### Configure VM for development
1. Attach the VMware tools CD to the appliance VM:

	Select: __`Virtual Machine->Reinstall VMware Tools`__

	__NOTE__: There's a bug in the Shared Folders feature of VMware Fusion 6.0.2.
	If running that version, you must attach a downgraded version of the tools
	by following the instructions [here](downgrade-vmware-tools.md), instead of this step.

* Start the VM and login to the console.
* Hit __`<return>`__ to get the console menu.
* Select __`Stop EVM Server Process`__, and __`y`__ to confirm.

The following steps are performed in a terminal window on the MAC.

1. Change to the script parent directory in the guides repo cloned earlier.

	__`cd <path to cloned guides repo>/miq-dev-appliance-setup/MAC`__

* Copy the __`on_appliance`__ directory to the appliance via __`scp`__.

	__`scp -r on_appliance root@<appliance IP>:`__

* Login to the appliance via __`ssh`__.

	__`ssh root@<appliance IP>:`__

* Change to the __`on_appliance`__ directory copied to the appliance earlier.

	__`cd /root/on_appliance`__

* Run the __`run-all.sh`__ script.

	__`./run-all.sh <hgfs_path_to_miq_dir>`__

	Where:  __`<hgfs_path_to_miq_dir>`__ is the path to the miq directory, relative to the MAC directory that will be shared with the appliance in the next step.

	For example: If the directory __`/Users/my_home`__ is to be shared with the appliance,
	__`<hgfs_path_to_miq_dir>`__ would be something like __`my_home/src/git/miq`__.

* When prompted as follows:

	__`Enable sharing in the VM and attach the appropriate host directory.`__

	__`Type <return> to continue, or enter a new path (q to quit):`__

	Before continuing, enable shared folders and attach the MAC directory to the VM:

	* For the VMware Fusion appliance VM, select: __`Virtual Machine->Settings...`__
	* Select: __`Sharing`__.
	* Set __`Shared Folders`__ to __`on`__.
	* Select __`+`__ to add a new shared folder from your MAC
	(a folder from which you can access the miq code. __`/Users/my_home`__ for example)

	Once the folder is attached, __`Type <return> to continue`__.

* Once the script completes, shut down the appliance and create another snapshot if you like.
* Boot the appliance and try to access the application from your web browser.
If all is well, you're done.

### Ongoing
Whenever code is updated on the MAC, the __`source-updated.sh`__
script should be run on the appliance.
In addition to recreating symbolic links, this script also performs a

__`bundle install`__ and a __`rake db:migrate`__.
