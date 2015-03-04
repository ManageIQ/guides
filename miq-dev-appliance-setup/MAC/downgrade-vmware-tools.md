## VMware Fusion 6.0.2 Shared Folders Workaround
There's a bug in the Shared Folders feature of VMware Fusion 6.0.2
that results in inconsistent data sharing between the host and guest OS.
Until VMware releases a fix for this issue, it seems the only workaround
is to use an older version of VMware Tools.

1. Goto: [https://softwareupdate.vmware.com/cds/vmw-desktop/fusion/6.0.1/1331545/packages/](https://softwareupdate.vmware.com/cds/vmw-desktop/fusion/6.0.1/1331545/packages/)
* Download __`com.vmware.fusion.tools.linux.zip.tar`__
* Untar and unzip the package until you extract the directory containing
the __`linux.iso`__ file
* On the VM whose VMware tools are to be downgraded:
	* Select __`Virtual Machine->Settings...`__ then __`CD/DVD`__.
	* Set __`Enable CD/DVD Drive`__ to __`ON`__.
	* From the drop-down, select __`Choose a disk or disk image...`__
	* Navigate to the directory extracted earlier and select the __`linux.iso`__ file.
	* Select __`Open`__.
* Install/Reinstall VMware tools as you normally would.

Note: The downloaded VMware tools package appears to be in a form that can be
imported into VMware Fusion, replacing the tools tha get installed via:

__`Virtual Machine->Install VMware Tools`__

However, I've been unsuccessful in doing so.
