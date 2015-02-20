#!/bin/bash

# Make sure the VM has a virtual CD/DVD device.
if [[ ! -b /dev/cdrom ]]
then
	echo "The appliance does not have a CD/DVD device." >&2
	echo "Add a virtual CD/DVD drive before rerunning this script." >&2
	exit 1
fi

# Ensure the VMware Tool installation media is attached to the VM.
while true
do
	mount | grep /media > /dev/null 2>&1 && { echo "Media already mounted, continuing..."; break; }

	if ! mount -r /dev/cdrom /media > /dev/null 2>&1
	then
		echo "The VMware Tools installation media is not accessible."
		echo "Select: \"Virtual Machine->[Re]install VMware Tools\""
		echo -n "Type <return> to continue (q to quit): "
		read RESP
		[[ $RESP = "q" ]] && exit 1
		continue
	else
		break
	fi
done

cd /media || exit 1
[ -f VMwareTools*.tar.gz ] || { echo "Unrecognized VMware Tools installation media." >&2; exit 1; }
echo "Detected VMware Tools installation media, installing..."

# Extract the VMware Tools archive.
echo "**** Extract the VMware Tools archive..."
rm -rf /root/vmware-tools-distrib
tar -C /root -xzf VMwareTools*.tar.gz || exit 1
echo "**** done."
cd /
umount /media

# Install VMware Tools.
echo "**** Installing VMware Tools..."
cd /root/vmware-tools-distrib || exit 1
./vmware-install.pl --default || exit 1
echo "**** done."

exit 0
