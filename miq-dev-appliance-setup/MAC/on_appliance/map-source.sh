#!/bin/bash

. $(dirname $_)/defines.sh
HGFS_MIQ_DIR=/mnt/hgfs/${1:-miq}

# Ensure host files are accessible.
while true
do
	if [[ ! -d $HGFS_MIQ_DIR || ! -d $HGFS_MIQ_DIR/vmdb ]]
	then
		if [[ ! -d $HGFS_MIQ_DIR ]]
		then
			echo "$HGFS_MIQ_DIR does not exist."
			echo "Enable sharing in the VM and attach the appropriate host directory."
		elif [[ ! -d $HGFS_MIQ_DIR/vmdb ]]
		then
			echo "$HGFS_MIQ_DIR is not a root miq directory."
		fi
		echo -n "Type <return> to continue, or enter a new path (q to quit): "
		read RESP
		[[ $RESP = "q" ]] && exit 1
		[[ $RESP = "" ]] && continue
		HGFS_MIQ_DIR="/mnt/hgfs/$RESP"
	else
		break
	fi
done

# Replace the installed miq code with a reference to the code on the MAC.
[[ -d $MIQ_SAV_DIR || -L $MIQ_DIR ]] || mv $MIQ_DIR $MIQ_SAV_DIR
[[ -L $MIQ_DIR ]] && rm -f $MIQ_DIR
ln -f -s $HGFS_MIQ_DIR $MIQ_DIR || exit 1

# Ensure we use the same region number as the original appliance.
cp $MIQ_SAV_DIR/vmdb/REGION $MIQ_DIR/vmdb/REGION

# The path to the ruby command is added by the build.
# We don't want to add the path to the default/evm file in the source tree,
# so we break the link to the source tree evm file and update a copy
# that's directly in /etc/default.
cd /etc/default
rm -f evm
cp $MIQ_DIR/system/LINK/etc/default/evm evm
ruby_bin_path=(/opt/rubies/ruby-2.0.0*/bin)
echo "export PATH=\$PATH:$ruby_bin_path" >> evm

# For some reason, files in /etc/init, that are links to files in the shared
# folders, are not honored by init. To fix this, we just copy the contents of
# the files in question to their respective files in /etc/init.
cd /etc/init
[[ -d miqconsole.conf.orig ]] || mv miqconsole.conf miqconsole.conf.orig
cp $MIQ_DIR/system/LINK/etc/init/miqconsole.conf miqconsole.conf
[[ -d evm_watchdog.conf.orig ]] || mv evm_watchdog.conf evm_watchdog.conf.orig
cp $MIQ_DIR/system/LINK/etc/init/evm_watchdog.conf evm_watchdog.conf

# For fleecing, saving intermediate data to the /var/www/miq/vmdb/data/metadata
# directory doesn't seem to work reliably through shared folders. To fix this,
# create a local directory for the metadata and create a symbolic link to it.
[[ -d $METADATA_DIR ]] || mkdir -p $METADATA_DIR
[[ -d $MIQ_DIR/vmdb/data ]] || mkdir -p $MIQ_DIR/vmdb/data
[[ -d $MIQ_DIR/vmdb/data/metadata && ! -L $MIQ_DIR/vmdb/data/metadata ]] && rmdir $MIQ_DIR/vmdb/data/metadata
ln -f -s $METADATA_DIR $MIQ_DIR/vmdb/data/metadata

# Create link to NetApp library Ruby bindings.
# cd $MIQ_DIR/lib/NetappManageabilityAPI/NmaCore || exit 1
# [[ -d lib && ! -L lib ]] && rm -rf lib
# [[ -L lib ]] && rm -f lib
# ln -f -s $MIQ_SAV_DIR/lib/NetappManageabilityAPI/NmaCore/lib lib

# Create link to MiqBlockDevOps.so
cd $MIQ_DIR/lib/disk/modules || exit 1
[[ -L MiqBlockDevOps.so ]] && rm -f MiqBlockDevOps.so
ln -f -s $MIQ_SAV_DIR/lib/disk/modules/MiqBlockDevOps.so MiqBlockDevOps.so

exit 0
