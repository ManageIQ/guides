#!/bin/bash

PACKAGES=$(cat <<-END_PACKAGES
		fuse
	END_PACKAGES
)
PACKAGE_GROUPS=$(cat <<-END_PACKAGE_GROUPS
	END_PACKAGE_GROUPS
)

# Set SELINUX to permissive mode.
if cd /etc/selinux
then
	if grep "SELINUX=enforcing" config > /dev/null 2>&1
	then
		echo "**** Setting SELINUX to permissive..."
		setenforce Permissive
		mv config config.sav
		sed -e "s/SELINUX=enforcing/SELINUX=permissive/" < config.sav > config
		echo "**** done."
	fi
fi

# Install the required software packages.
echo "**** Installing software..."
OIFS="$IFS"
IFS=$'\n'
for P in $PACKAGE_GROUPS
do
	echo "******** Installing package group: $P..."
	yum -y groupinstall "$P" || exit 1
	echo "******** Install package group: $P done"
	echo
done
IFS="$OIFS"

for P in $PACKAGES
do
	echo "******** Installing package: $P..."
	yum -y install "$P" || exit 1
	echo "******** Install package: $P done"
	echo
done
echo "**** Install software done."
echo

exit 0
